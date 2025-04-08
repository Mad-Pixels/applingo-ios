import SwiftUI

internal struct GameQuizViewAnswerRecord: View {
    @EnvironmentObject var themeManager: ThemeManager

    let languageCode: String
    @Binding var recognizedText: String

    var body: some View {
        VStack(spacing: 8) {
            SectionBody(content: {
                DynamicText(
                    model: DynamicTextModel(text: recognizedText),
                    style: .headerGame(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 4
                    )
                )
                .frame(height: 72)
            },
                style: .accent(themeManager.currentThemeStyle)
            )
            .padding(.vertical, 24)
            
            Spacer()
        }
        .onDisappear{
            recognizedText = ""
        }
        .frame(height: 328)
    }
}
