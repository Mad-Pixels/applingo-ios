import SwiftUI

struct GameFloatingButtonRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isRecording: Bool = false
    @State private var fullLangCode: String = ""
    
    internal let languageCode: String
    internal let disabled: Bool
    internal let onRecognized: (String) -> Void

    var body: some View {
        ButtonFloatingSingle(
            icon: isRecording ? "stop.circle.fill" : "mic.circle.fill",
            action: {
                if isRecording {
                    ASR.shared.stopRecognition()
                    isRecording = false
                } else {
                    startRecognition()
                }
            },
            disabled: disabled
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
            fullLangCode = TTSLanguageType.shared.get(for: languageCode)
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
