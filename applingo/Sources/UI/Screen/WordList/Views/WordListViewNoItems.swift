import SwiftUI

/// A view that displays a placeholder when no words are available.
struct WordListViewNoItems: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle

    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    init(style: WordListStyle, locale: WordListLocale) {
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Computed Properties
    /// The image name to display based on the current theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "warning_dark" : "warning_light"
    }
    
    // MARK: - Body
    var body: some View {
        VStack {
            Image(warningImageName)
                .resizable()
                .scaledToFit()
                .frame(width: style.iconSize, height: style.iconSize)
            
            Text(locale.screenNoWords)
                .font(style.titleFont)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}
