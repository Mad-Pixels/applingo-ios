import SwiftUI

/// A view that displays a "no words found" message in the game.
struct GameNoWords: View {
    // MARK: - State Objects
    @StateObject private var locale = GameNoWordsLocale()
    @StateObject private var style: GameNoWordsStyle
    
    // MARK: - Initializer
    /// Initializes the GameNoWords view.
    /// - Parameter style: Optional style configuration; if nil, a themed style is applied.
    init(style: GameNoWordsStyle? = nil) {
        _style = StateObject(wrappedValue: style ?? GameNoWordsStyle.themed(ThemeManager.shared.currentThemeStyle))
    }
    
    // MARK: - Body
    var body: some View {
        SectionBody {
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                Image("words_not_found")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                SectionHeader(
                    title: locale.screenSubtitleNoWords,
                    style: .heading(ThemeManager.shared.currentThemeStyle)
                )
                
                Text(locale.screenTextNoWords)
                    .font(style.textFont)
                    .foregroundStyle(style.textColor)
                    .padding(.top, -8)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
