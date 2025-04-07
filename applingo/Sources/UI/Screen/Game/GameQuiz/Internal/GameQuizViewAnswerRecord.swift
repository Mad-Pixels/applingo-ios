import SwiftUI

internal struct GameQuizViewAnswerRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    let languageCode: String
    @Binding var recognizedText: String

    var body: some View {
        VStack(spacing: 8) {
            if !recognizedText.isEmpty {
                DynamicText(
                    model: DynamicTextModel(text: recognizedText),
                    style: .textGame(themeManager.currentThemeStyle)
                )
            }
        }
    }
}

