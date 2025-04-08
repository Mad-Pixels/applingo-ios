import SwiftUI

internal struct GameNoWordsAddFromWords: View {
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
                DynamicText(
                    model: DynamicTextModel(text: locale.screenTabWordsDescription),
                    style: .textGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 2
                    )
                )
                        
                Image(ThemeManager.shared.currentTheme.asString == "Dark" ?
                        "word_tab_dark" : "word_tab_light"
                )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 125)
                    .padding(.top, -8)
                    .padding(.bottom, -16)
                        
                DynamicText(
                    model: DynamicTextModel(text: locale.tabWordsDescriptionActions),
                    style: .textGame(
                        ThemeManager.shared.currentThemeStyle,
                        lineLimit: 1
                    )
                )

                DynamicText(
                    model: DynamicTextModel(text: " - " + locale.screenImportOptionRemote),
                    style: .textMain(
                        ThemeManager.shared.currentThemeStyle,
                        lineLimit: 2
                    )
                )
                
                DynamicText(
                    model: DynamicTextModel(text: " - " + locale.screenImportOptionLocal),
                    style: .textMain(
                        ThemeManager.shared.currentThemeStyle,
                        lineLimit: 1
                    )
                )
                        
                Image(ThemeManager.shared.currentTheme.asString == "Dark" ?
                        "words_get_dark" : "words_get_light"
                )
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .frame(height: 220)
            }
            .padding(8)
        }
    }
}
