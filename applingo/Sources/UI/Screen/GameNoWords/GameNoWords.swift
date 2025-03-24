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
        VStack(spacing: 20) {
            Spacer()
            
            VStack(alignment: .center, spacing: 16) {
//                Spacer()
                
                SectionHeader(
                    title: locale.screenSubtitleNoWords,
                    style: .centeredHeading(ThemeManager.shared.currentThemeStyle)
                )
                
                Image("no_words_game")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                
                Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "word_tab_dark" : "word_tab_light")
                    .resizable()
                    .scaledToFit()
                    .frame( height: 125)
                
                Text(locale.screenTextNoWords)
                    .font(style.textFont)
                    .foregroundStyle(style.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                ButtonAction(
                    title: locale.screenButtonClose,
                    action: { dismiss() },
                    style: .action(ThemeManager.shared.currentThemeStyle)
                )
                .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
            
//            Spacer()
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
