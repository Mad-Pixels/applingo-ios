import SwiftUI

/// A view that displays a "no words found" message in the game.
struct GameNoWords: View {
    // MARK: - State Objects
    @StateObject private var locale = GameNoWordsLocale()
    @StateObject private var style: GameNoWordsStyle

    // MARK: - Environment
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initializer
    /// Initializes the GameNoWords view.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(style: GameNoWordsStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? GameNoWordsStyle.themed(ThemeManager.shared.currentThemeStyle))
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer().frame(height: 64)
                
                SectionHeader(
                    title: locale.screenSubtitleNoWords,
                    style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                )
                SectionBody{
                    VStack(alignment: .center) {
                        Image("no_words_game")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 125)
                        
                        DynamicText(
                            model: DynamicTextModel(text: locale.screenNoWordsDescription),
                            style: .textCenter(ThemeManager.shared.currentThemeStyle)
                        )
                    }
                    .padding(8)
                }
                Spacer()
                
                SectionHeader(
                    title: locale.screenAddDictionariesTitle,
                    style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                )
                SectionBody{
                    VStack(alignment: .leading) {
                        DynamicText(
                            model: DynamicTextModel(text: locale.screenTabWordsDescription),
                            style: .textLeft(ThemeManager.shared.currentThemeStyle)
                        )
                        
                        Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "word_tab_dark" : "word_tab_light")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 125)
                        
                        DynamicText(
                            model: DynamicTextModel(text: locale.tabWordsDescriptionActions),
                            style: .textLeft(ThemeManager.shared.currentThemeStyle)
                        )
                        DynamicText(
                            model: DynamicTextModel(text: " - " + locale.screenImportOptionRemote),
                            style: .textLeft(ThemeManager.shared.currentThemeStyle)
                        )
                        DynamicText(
                            model: DynamicTextModel(text: " - " + locale.screenImportOptionLocal),
                            style: .textLeft(ThemeManager.shared.currentThemeStyle)
                        )
                        
                        Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "words_get_dark" : "words_get_light")
                            .resizable()
                            .cornerRadius(20)
                            .scaledToFit()
                            .frame(height: 220)
                    }
                    .padding(8)
                }
                Spacer()
                
                SectionHeader(
                    title: locale.screenAddDictionariesChoice,
                    style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                )
                SectionBody{
                    VStack(alignment: .leading) {
                        Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "dictionaries_tab_dark" : "dictionaries_tab_light")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 125)
                        
                        DynamicText(
                            model: DynamicTextModel(text: locale.screenTabDictionariesDescriptionImport),
                            style: .textLeft(ThemeManager.shared.currentThemeStyle)
                        )
                        
                        HStack {
                            DynamicText(
                                model: DynamicTextModel(text: locale.screenImportOptionRemote),
                                style: .textLeft(ThemeManager.shared.currentThemeStyle)
                            )
                            
                            Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "dictionaries_remote_dark" : "dictionaries_remote_light")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 64)
                        }
                        
                        HStack {
                            DynamicText(
                                model: DynamicTextModel(text: locale.screenImportOptionLocal),
                                style: .textLeft(ThemeManager.shared.currentThemeStyle)
                            )
                            
                            Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "dictionaries_local_dark" : "dictionaries_local_light")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 64)
                        }
                    }
                    .padding(8)
                }
                Spacer()
                
                ButtonAction(
                    title: locale.screenButtonClose,
                    action: { dismiss() },
                    style: .action(ThemeManager.shared.currentThemeStyle)
                )
                .padding(.bottom)
                
                // Добавляем отступ снизу для лучшего вида при скролле
                //Spacer().frame(height: 20)
            }
            .padding()
        }
        .padding(.horizontal, 8)
        .background(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
