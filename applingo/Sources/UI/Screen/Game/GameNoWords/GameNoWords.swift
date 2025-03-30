import SwiftUI

struct GameNoWords: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var locale = GameNoWordsLocale()
    @StateObject private var style: GameNoWordsStyle

    /// Initializes the GameNoWords.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(style: GameNoWordsStyle = GameNoWordsStyle.themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }

    var body: some View {
        BaseScreen(
            screen: .WordNotFound
        ) {
            VStack{
                ScrollView {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenSubtitleNoWords),
                        style: .headerMain(
                            themeManager.currentThemeStyle,
                            alignment: .center
                        )
                    )
                        
                    GameNoWordsMsg(
                        style: style,
                        locale: locale
                    )
                    .padding(.bottom, style.padding.bottom)
                        
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenAddDictionariesTitle),
                        style: .headerMain(
                            themeManager.currentThemeStyle,
                            alignment: .center
                        )
                    )
                        
                    GameNoWordsAddFromWords(
                        style: style,
                        locale: locale
                    )
                    .padding(.bottom, style.padding.bottom)
                        
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenAddDictionariesChoice),
                        style: .headerMain(
                            themeManager.currentThemeStyle,
                            alignment: .center
                        )
                    )
                        
                    GameNoWordsAddFromDictionary(
                        style: style,
                        locale: locale
                    )
                    .padding(.bottom, style.padding.bottom)
                }
                
                ButtonAction(
                    title: locale.screenButtonClose,
                    action: { dismiss() },
                    style: .action(ThemeManager.shared.currentThemeStyle)
                )
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 8)
            .scrollIndicators(.hidden)
        }
        .padding(.top, 64)
        .padding(style.padding)
    }
}
