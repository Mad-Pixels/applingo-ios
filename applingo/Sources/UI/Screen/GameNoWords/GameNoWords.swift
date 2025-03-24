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
        // Оборачиваем весь контент в ScrollView
        ScrollView {
            VStack(spacing: 20) {
                // Добавляем небольшой отступ сверху для лучшего вида при скролле
                Spacer().frame(height: 64)
                
                VStack(alignment: .center, spacing: 16) {
                    SectionHeader(
                        title: locale.screenSubtitleNoWords,
                        style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                    )
                    
                    Image("no_words_game")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 125)
                    
                    SectionHeader(
                        title: locale.screenAddDictionariesTitle,
                        style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                    )
                    
                    Text(locale.screenTabWordsDescription)
                        .font(style.textFont)
                        .foregroundStyle(style.textColor)
                        .padding(.horizontal)
                    
                    Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "word_tab_dark" : "word_tab_light")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 125)
                    
                    Text(locale.screenTabWordsDescriptionImport)
                        .font(style.textFont)
                        .foregroundStyle(style.textColor)
                        .padding(.horizontal)
                    
                    Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "words_get_dark" : "words_get_light")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 220)
                    
                    Text(locale.screenAddDictionariesChoice)
                        .font(style.textFont)
                        .foregroundStyle(style.textColor)
                        .padding(.horizontal)
                    
                    Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "dictionaries_tab_dark" : "dictionaries_tab_light")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 125)
                    
                    Text(locale.screenTabDictionariesDescriptionImport)
                        .font(style.textFont)
                        .foregroundStyle(style.textColor)
                        .padding(.horizontal)
                    
                    HStack {
                        VStack{
                            Text("some text")
                            Text("some text")
                        }
                        
                        Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "dictionaries_get_dark" : "dictionaries_get_light")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    
                    ButtonAction(
                        title: locale.screenButtonClose,
                        action: { dismiss() },
                        style: .action(ThemeManager.shared.currentThemeStyle)
                    )
                    .padding(.bottom)
                }
                .frame(maxWidth: .infinity)
                
                // Добавляем отступ снизу для лучшего вида при скролле
                Spacer().frame(height: 20)
            }
            .padding()
        }
        // Устанавливаем цвет фона для ScrollView
        .background(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
        // Отключаем индикатор скролла для более чистого вида
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
