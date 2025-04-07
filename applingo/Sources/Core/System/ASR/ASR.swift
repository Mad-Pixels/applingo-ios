import AVFoundation
import Foundation
import Speech

@MainActor
final class ASR: NSObject, SFSpeechRecognizerDelegate, Sendable {
    static let shared = ASR()

    @Published private(set) var isRecording = false
    @Published var transcription: String = ""
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var completionHandler: ((String?) -> Void)?
    private var isProcessing = false
    
    override init() {
        super.init()
    }

    @MainActor
    func requestAccessIfNeeded() async {
        let speechStatus = await requestAuthorization()
        AppStorage.shared.useASR = (speechStatus == .authorized)

        let micStatus = await requestMicrophoneAccess()
        AppStorage.shared.useMicrophone = micStatus

        AppStorage.shared.noRecord = !AppStorage.shared.useASR || !AppStorage.shared.useMicrophone
        Logger.debug("[ASR]: Authorization status", metadata: [
            "speech": String(describing: speechStatus),
            "mic": micStatus.description,
            "useASR": AppStorage.shared.useASR.description,
            "useMicrophone": AppStorage.shared.useMicrophone.description,
            "noRecord": AppStorage.shared.noRecord.description
        ])
    }

    func isAvailable(for languageCode: String) -> Bool {
        guard setupSpeechRecognizer(with: languageCode) else {
            return false
        }
        return speechRecognizer?.isAvailable ?? false
    }

    func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }

    func startRecognition(languageCode: String, completion: @escaping (String?) -> Void) async throws {
        guard !isProcessing else {
            completion(nil)
            return
        }

        isProcessing = true
        cleanupResources()

        do {
            let authStatus = await requestAuthorization()
            guard authStatus == .authorized else {
                isProcessing = false
                throw ASRError.authorizationDenied
            }

            guard setupSpeechRecognizer(with: languageCode) else {
                Logger.debug("[ASR]: Unsupported language", metadata: [
                    "language": languageCode
                ])
                isProcessing = false
                throw ASRError.unsupportedLanguage(code: languageCode)
            }

            guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
                isProcessing = false
                throw ASRError.unsupportedLanguage(code: languageCode)
            }

            try setupAudioSession()

            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            self.recognitionRequest = request

            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.inputFormat(forBus: 0)

            Logger.debug("[ASR]: Recording format initialized", metadata: [
                "sampleRate": String(recordingFormat.sampleRate),
                "channels": String(recordingFormat.channelCount)
            ])

            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }

            audioEngine.prepare()
            try audioEngine.start()

            self.completionHandler = completion
            self.transcription = ""
            self.isRecording = true

            recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
                guard let self = self else { return }

                var isFinal = false

                if let error = error {
                    Logger.debug("[ASR]: Recognition error", metadata: [
                        "error": error.localizedDescription
                    ])

                    if !self.transcription.isEmpty && error.localizedDescription.contains("No speech detected") {
                        Logger.debug("[ASR]: Ignoring 'no speech' error, partial result exists")
                        return
                    }
                }

                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    Logger.debug("[ASR]: Transcription updated", metadata: [
                        "text": recognizedText
                    ])
                    self.transcription = recognizedText
                    isFinal = result.isFinal

                    if isFinal {
                        Logger.debug("[ASR]: Final transcription received")
                    }
                }

                if error != nil || isFinal {
                    self.finishRecognition(isFinal: isFinal || !self.transcription.isEmpty)
                }
            }
        } catch {
            Logger.debug("[ASR]: Exception during recognition", metadata: [
                "error": error.localizedDescription
            ])
            cleanupResources()
            isProcessing = false
            isRecording = false
            throw error
        }
    }

    func stopRecognition() {
        finishRecognition(isFinal: !transcription.isEmpty)
    }

    func getSupportedLanguages() -> [String] {
        let locales = SFSpeechRecognizer.supportedLocales()
        return locales.map { $0.identifier }
    }

    nonisolated func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        Logger.debug("[ASR]: Recognizer availability changed", metadata: [
            "available": available.description
        ])
    }

    private func setupSpeechRecognizer(with languageCode: String) -> Bool {
        Logger.debug("[ASR]: Setting up speech recognizer", metadata: [
            "language": languageCode
        ])

        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode)) else {
            Logger.debug("[ASR]: Failed to create recognizer", metadata: [
                "language": languageCode
            ])
            return false
        }

        speechRecognizer = recognizer
        speechRecognizer?.delegate = self

        Logger.debug("[ASR]: Recognizer initialized", metadata: [
            "isAvailable": recognizer.isAvailable.description
        ])
        return true
    }

    private func setupAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()

        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        Thread.sleep(forTimeInterval: 0.1)

        try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker, .allowBluetooth])

        if let availableInputs = audioSession.availableInputs,
           let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) {
            try audioSession.setPreferredInput(builtInMicInput)
        }

        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        Logger.debug("[ASR]: Audio session configured", metadata: [
            "inputs": audioSession.availableInputs?.map { $0.portType.rawValue }.joined(separator: ", ") ?? "none"
        ])
    }

    private func finishRecognition(isFinal: Bool) {
        Logger.debug("[ASR]: Finishing recognition", metadata: [
            "isFinal": isFinal.description
        ])

        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            Logger.debug("[ASR]: Audio engine stopped")
        }

        recognitionRequest?.endAudio()

        if isFinal {
            completionHandler?(transcription)
        } else {
            completionHandler?(nil)
        }

        cleanupResources()
        isProcessing = false
        isRecording = false

        NotificationCenter.default.post(name: .ASRDidFinishRecognition, object: nil)
    }

    private func cleanupResources() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }

        recognitionTask?.cancel()
        recognitionTask = nil
        recognitionRequest = nil

        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    private func requestMicrophoneAccess() async -> Bool {
        await withCheckedContinuation { continuation in
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
    }
}
