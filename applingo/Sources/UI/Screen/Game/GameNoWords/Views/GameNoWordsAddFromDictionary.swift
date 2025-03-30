import SwiftUI

internal struct GameNoWordsAddFromDictionary: View {
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
                Image(ThemeManager.shared.currentTheme.asString == "Dark" ?
                        "dictionaries_tab_dark" : "dictionaries_tab_light"
                )
                    .resizable()
                    .scaledToFit()
                    .frame(height: 125)
                    .padding(.top, -8)
                    .padding(.bottom, -16)
                        
                DynamicText(
                    model: DynamicTextModel(text: locale.screenTabDictionariesDescriptionImport),
                    style: .textGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 2
                    )
                )
                        
                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenImportOptionRemote),
                        style: .textMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 1
                        )
                    )
                                                    
                    Image(ThemeManager.shared.currentTheme.asString == "Dark" ?
                            "dictionaries_remote_dark" : "dictionaries_remote_light"
                    )
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                }
                    
                HStack {
                    DynamicText(
                        model: DynamicTextModel(text: locale.screenImportOptionLocal),
                        style: .textMain(
                            ThemeManager.shared.currentThemeStyle,
                            alignment: .trailing,
                            lineLimit: 2
                        )
                    )
                                            
                    Image(ThemeManager.shared.currentTheme.asString == "Dark" ?
                            "dictionaries_local_dark" : "dictionaries_local_light"
                    )
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                }
            }
            .padding(8)
        }
    }
}
