import SwiftUI

struct GameFloatingButtonRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isRecording: Bool = false
    @State private var fullLangCode: String = ""
    @State private var isPrepared: Bool = false

    internal let languageCode: String
    internal let disabled: Bool
    internal let onRecognized: (String) -> Void

    init(
        languageCode: String,
        disabled: Bool,
        onRecognized: @escaping (String) -> Void
    ) {
        self.languageCode = languageCode
        self.disabled = disabled
        self.onRecognized = onRecognized
    }

    var body: some View {
        ButtonFloatingSingle(
            icon: isRecording ? "stop.circle.fill" : "mic.circle.fill",
            action: {
                if isRecording {
                    ASR.shared.stopRecognition()
                    isRecording = false
                } else if isPrepared {
                    startRecognition()
                }
            },
            disabled: disabled || !isPrepared
        )
        .waveEffect(
            isActive: isRecording,
            colors: [
                themeManager.currentThemeStyle.accentPrimary,
                themeManager.currentThemeStyle.accentDark,
                themeManager.currentThemeStyle.accentLight
            ],
            radius: 5
        )
        .onAppear {
            prepareASR()
        }
        .onReceive(NotificationCenter.default.publisher(for: .ASRDidFinishRecognition)) { _ in
            let recognized = ASR.shared.transcription.trimmingCharacters(in: .whitespacesAndNewlines)
            if !recognized.isEmpty {
                onRecognized(recognized)
            }
            isRecording = false
        }
        .onDisappear {
            if isRecording {
                ASR.shared.stopRecognition()
                isRecording = false
            }
        }
    }

    private func prepareASR() {
        Task {
            fullLangCode = TTSLanguageType.shared.get(for: languageCode)

            let isSupported = ASR.shared.isAvailable(for: fullLangCode)
            if !isSupported {
                Logger.debug("[GameFloatingBtnRecord] Language not supported", metadata: [
                    "lang": fullLangCode
                ])
                isPrepared = false
                return
            }

            let authStatus = await ASR.shared.requestAuthorization()
            if authStatus == .authorized {
                Logger.debug("[GameFloatingBtnRecord] ASR is ready", metadata: [
                    "lang": fullLangCode
                ])
                isPrepared = true
            } else {
                Logger.debug("[GameFloatingBtnRecord] Authorization denied", metadata: [
                    "status": String(describing: authStatus)
                ])
                isPrepared = false
            }
        }
    }

    private func startRecognition() {
        Task {
            do {
                try await ASR.shared.startRecognition(languageCode: fullLangCode) { _ in }
                isRecording = true
            } catch {
                Logger.error("[GameFloatingBtnRecord] Failed to start recognition", metadata: [
                    "lang": fullLangCode,
                    "error": error.localizedDescription
                ])
                isRecording = false
            }
        }
    }
}
