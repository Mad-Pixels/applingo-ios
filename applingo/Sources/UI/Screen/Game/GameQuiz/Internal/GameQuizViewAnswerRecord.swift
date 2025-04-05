import SwiftUI

internal struct GameQuizViewAnswerRecord: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    let languageCode: String
    let onRecognized: (String) -> Void
    
    @State private var isRecording = false
    @State private var isAvailable = true
    @State private var fullLangCode: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                if isRecording {
                    ASR.shared.stopRecognition()
                } else {
                    startRecognition()
                }
                isRecording.toggle()
            }) {
                Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(themeManager.currentThemeStyle.accentPrimary)
            }
            .disabled(!isAvailable)
        }
        .onAppear {
            let resolvedCode = TTSLanguageType.shared.get(for: languageCode)
            fullLangCode = resolvedCode
            isAvailable = ASR.shared.isAvailable(for: resolvedCode)
        }
        .onReceive(NotificationCenter.default.publisher(for: .ASRDidFinishRecognition)) { _ in
            let recognized = ASR.shared.transcription.trimmingCharacters(in: .whitespacesAndNewlines)
            if !recognized.isEmpty {
                onRecognized(recognized)
            }
            isRecording = false
        }
    }
    
    private func startRecognition() {
        Task {
            do {
                try await ASR.shared.startRecognition(languageCode: fullLangCode) { _ in }
            } catch {
                print("ASR error: \(error)")
                isRecording = false
            }
        }
    }
}
