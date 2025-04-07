import SwiftUI

internal struct GameQuizViewAnswerRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    let languageCode: String
    let onRecognized: (String) -> Void

    @State private var recognizedText: String = ""

    var body: some View {
        VStack(spacing: 8) {
            if !recognizedText.isEmpty {
                DynamicText(
                    model: DynamicTextModel(text: recognizedText),
                    style: .textGame(themeManager.currentThemeStyle)
                )
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .ASRDidFinishRecognition)) { _ in
            let text = ASR.shared.transcription.trimmingCharacters(in: .whitespacesAndNewlines)
            if !text.isEmpty {
                recognizedText = text
                onRecognized(text)
            }
        }
    }
}
