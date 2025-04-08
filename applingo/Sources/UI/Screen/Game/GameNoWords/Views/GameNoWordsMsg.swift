import SwiftUI

internal struct GameNoWordsMsg: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: GameNoWordsLocale
    private let style: GameNoWordsStyle
    
    /// Initializes the GameNoWordsMsg.
    ///  - Parameters:
    ///   - style: A `GameNoWordsStyle` object defining the visual style of the view.
    ///   - locale: A `GameNoWordsLocale` object providing localized strings.
    init(
        style: GameNoWordsStyle,
        locale: GameNoWordsLocale
    ) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionBody {
            VStack(alignment: .center) {
                Image("no_words_game")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)

                DynamicText(
                    model: DynamicTextModel(text: locale.screenNoWordsDescription),
                    style: .textGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 6
                    )
                )
            }
            .padding(8)
        }
    }
}
