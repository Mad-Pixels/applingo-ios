import Foundation
import Speech
import AVFoundation

@MainActor
final class ASR: NSObject, SFSpeechRecognizerDelegate, Sendable {
    static let shared = ASR()
    
    private var speechRecognizer: SFSpeechRecognizer?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var completionHandler: ((String?) -> Void)?
    private var isProcessing = false
    
    @Published private(set) var isRecording = false
    @Published  var transcription: String = ""
    
    private override init() {
        super.init()
        print("ASR: Инициализация")
    }
    
    private func setupSpeechRecognizer(with languageCode: String) -> Bool {
        print("ASR: Настройка распознавателя для языка: \(languageCode)")
        
        // Защита от несуществующего языка
        guard let recognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode)) else {
            print("ASR: Не удалось создать распознаватель для языка \(languageCode)")
            return false
        }
        
        speechRecognizer = recognizer
        speechRecognizer?.delegate = self
        
        print("ASR: Распознаватель настроен, доступность: \(recognizer.isAvailable)")
        return true
    }
    
    /// Проверяет доступность распознавания речи
    func isAvailable(for languageCode: String) -> Bool {
        guard setupSpeechRecognizer(with: languageCode) else {
            return false
        }
        return speechRecognizer?.isAvailable ?? false
    }
    
    /// Запрашивает разрешение на распознавание речи
    func requestAuthorization() async -> SFSpeechRecognizerAuthorizationStatus {
        print("ASR: Запрос авторизации")
        return await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                print("ASR: Статус авторизации: \(status.rawValue)")
                continuation.resume(returning: status)
            }
        }
    }
    
    /// Начинает распознавание речи
    func startRecognition(
        languageCode: String,
        completion: @escaping (String?) -> Void
    ) async throws {
        print("ASR: Начало распознавания на языке: \(languageCode)")
        
        // Защита от повторного вызова
        guard !isProcessing else {
            print("ASR: Уже выполняется распознавание")
            completion(nil)
            return
        }
        
        // Устанавливаем флаг блокировки
        isProcessing = true
        
        // Сбрасываем состояние на всякий случай
        cleanupResources()
        
        do {
            // Проверяем авторизацию
            let authStatus = await requestAuthorization()
            guard authStatus == .authorized else {
                print("ASR: Нет авторизации")
                isProcessing = false
                throw ASRError.authorizationDenied
            }
            
            // Настраиваем распознаватель для указанного языка
            guard setupSpeechRecognizer(with: languageCode) else {
                print("ASR: Язык не поддерживается: \(languageCode)")
                isProcessing = false
                throw ASRError.unsupportedLanguage(code: languageCode)
            }
            
            // Проверяем доступность
            guard let speechRecognizer = speechRecognizer, speechRecognizer.isAvailable else {
                print("ASR: Распознаватель недоступен")
                isProcessing = false
                throw ASRError.unsupportedLanguage(code: languageCode)
            }
            
            // Настраиваем аудиосессию
            try setupAudioSession()
            
            // Создаем запрос распознавания
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            self.recognitionRequest = request
            
            print("ASR: Запрос распознавания создан")
            
            // Настраиваем аудиовход
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.inputFormat(forBus: 0)
            
            print("ASR: Формат записи: \(recordingFormat)")
            
            // Устанавливаем "прослушку" на аудиовход
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }
            
            print("ASR: Аудиовход настроен")
            
            // Запускаем аудиодвижок
            audioEngine.prepare()
            try audioEngine.start()
            
            print("ASR: Аудиодвижок запущен")
            
            // Сохраняем обработчик завершения
            self.completionHandler = completion
            
            // Запускаем задачу распознавания
            self.transcription = ""
            self.isRecording = true
            
            print("ASR: Запуск задачи распознавания")
            
            recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
                guard let self = self else { return }
                
                var isFinal = false
                
                if let error = error {
                    print("ASR: Ошибка распознавания: \(error.localizedDescription)")
                    
                    // Некоторые ошибки (например, "No speech detected") не должны прерывать распознавание
                    // если у нас уже есть частичные результаты
                    if !self.transcription.isEmpty && error.localizedDescription.contains("No speech detected") {
                        print("ASR: Игнорируем ошибку, так как уже есть распознанный текст: \(self.transcription)")
                        return
                    }
                }
                
                if let result = result {
                    let recognizedText = result.bestTranscription.formattedString
                    print("ASR: Распознано: \(recognizedText)")
                    self.transcription = recognizedText
                    isFinal = result.isFinal
                    
                    if isFinal {
                        print("ASR: Финальный результат получен")
                    }
                }
                
                if error != nil || isFinal {
                    self.finishRecognition(isFinal: isFinal || !self.transcription.isEmpty)
                }
            }
        } catch {
            print("ASR: Исключение при запуске распознавания: \(error.localizedDescription)")
            
            // Очищаем ресурсы в случае ошибки
            cleanupResources()
            isProcessing = false
            isRecording = false
            throw error
        }
    }
    
    /// Настраивает аудиосессию для записи
    private func setupAudioSession() throws {
        print("ASR: Настройка аудиосессии")
        let audioSession = AVAudioSession.sharedInstance()
        
        // Сначала деактивируем текущую сессию
        try? audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        
        // Дадим системе время на переключение
        Thread.sleep(forTimeInterval: 0.1)
        
        // Используем категорию playAndRecord вместо record, чтобы поддерживать defaultToSpeaker
        try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: [.duckOthers, .defaultToSpeaker, .allowBluetooth])
        
        // Настраиваем предпочтительный ввод на встроенный микрофон
        if let availableInputs = audioSession.availableInputs,
           let builtInMicInput = availableInputs.first(where: { $0.portType == .builtInMic }) {
            try audioSession.setPreferredInput(builtInMicInput)
            print("ASR: Установлен предпочтительный ввод: встроенный микрофон")
        }
        
        // Активируем сессию
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        print("ASR: Аудиосессия настроена, доступные входы: \(audioSession.availableInputs?.map { $0.portType.rawValue } ?? [])")
    }
    
    /// Завершает процесс распознавания
    private func finishRecognition(isFinal: Bool) {
        print("ASR: Завершение распознавания, финальный результат: \(isFinal)")
        
        // Останавливаем аудиодвижок
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            print("ASR: Аудиодвижок остановлен")
        }
        
        // Завершаем запрос распознавания
        recognitionRequest?.endAudio()
        
        // Вызываем обработчик завершения
        if isFinal {
            print("ASR: Вызов обработчика с результатом: \(transcription)")
            completionHandler?(transcription)
        } else {
            print("ASR: Вызов обработчика без результата")
            completionHandler?(nil)
        }
        
        // Очищаем ресурсы
        cleanupResources()
        
        // Сбрасываем флаги
        isProcessing = false
        isRecording = false
        
        // Уведомляем об окончании распознавания
        NotificationCenter.default.post(name: .ASRDidFinishRecognition, object: nil)
        
        print("ASR: Распознавание завершено")
    }
    
    /// Останавливает распознавание речи
    func stopRecognition() {
        print("ASR: Запрос на остановку распознавания с текущим результатом: \(transcription)")
        
        // Если есть распознанный текст, завершаем с ним
        if !transcription.isEmpty {
            finishRecognition(isFinal: true)  // Всегда используем true если есть текст
        } else {
            finishRecognition(isFinal: false)
        }
    }
    
    /// Очищает ресурсы распознавания
    private func cleanupResources() {
        print("ASR: Очистка ресурсов")
        
        // Останавливаем аудиодвижок если он запущен
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            print("ASR: Аудиодвижок остановлен при очистке")
        }
        
        // Отменяем задачу распознавания
        recognitionTask?.cancel()
        recognitionTask = nil
        
        // Освобождаем запрос распознавания
        recognitionRequest = nil
        
        // Сбрасываем аудиосессию
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        
        print("ASR: Ресурсы очищены")
    }
    
    /// Вызывается при изменении доступности распознавателя речи
    nonisolated func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("ASR: Доступность распознавателя изменилась на \(available)")
    }
    
    /// Возвращает список поддерживаемых языков
    func getSupportedLanguages() -> [String] {
        let locales = SFSpeechRecognizer.supportedLocales()
        let identifiers = locales.map { $0.identifier }
        print("ASR: Поддерживаемые языки: \(identifiers)")
        return identifiers
    }
}

// Notification name
extension Notification.Name {
    static let ASRDidFinishRecognition = Notification.Name("ASRDidFinishRecognition")
}
