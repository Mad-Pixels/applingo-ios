import SwiftUI

struct GameFloatingButtonRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State private var isRecording: Bool = false
    @State private var isPrepared: Bool = false
    @State private var fullLangCode: String = ""
    @State private var asr: ASR? = nil

    let onRecognized: (String) -> Void
    let languageCode: String
    let disabled: Bool
    
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
                    stopRecognitionWithDelay()
                } else if isPrepared {
                    startRecognitionWithDelay()
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
            let recognized = asr?.transcription.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !recognized.isEmpty {
                onRecognized(recognized)
            }
            isRecording = false
        }
        .onDisappear {
            if isRecording {
                asr?.stopRecognition()
                isRecording = false
            }
        }
    }

    private func prepareASR() {
        Task {
            fullLangCode = TTSLanguageType.shared.get(for: languageCode)

            do {
                asr = try await ASRPrepare.shared.get(for: fullLangCode)
                Logger.debug("[GameFloatingButtonRecord] ASR ready", metadata: ["lang": fullLangCode])
                isPrepared = true
            } catch {
                Logger.error("[GameFloatingButtonRecord] Failed to prepare ASR", metadata: [
                    "lang": fullLangCode,
                    "error": error.localizedDescription
                ])
                isPrepared = false
            }
        }
    }

    private func startRecognition() {
        Task {
            do {
                try await asr?.startRecognition(languageCode: fullLangCode) { _ in }
                isRecording = true
            } catch {
                Logger.error("[GameFloatingButtonRecord] Failed to start recognition", metadata: [
                    "lang": fullLangCode,
                    "error": error.localizedDescription
                ])
                isRecording = false
            }
        }
    }
    
    private func startRecognitionWithDelay() {
        Task {
            do {
                try await asr?.startRecognition(languageCode: fullLangCode) { _ in }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    isRecording = true
                }
            } catch {}
        }
    }

    private func stopRecognitionWithDelay() {
        isRecording = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            asr?.stopRecognition()
        }
    }
}
