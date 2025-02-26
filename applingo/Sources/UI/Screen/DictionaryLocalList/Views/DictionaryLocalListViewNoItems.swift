import SwiftUI

struct DictionaryLocalListViewNoItems: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryLocalListLocale
    private let style: DictionaryLocalListStyle
    
    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `DictionaryLocalListStyle` object that defines the visual style.
    ///   - locale: `DictionaryLocalListLocale` object that provides localized strings.
    init(style: DictionaryLocalListStyle, locale: DictionaryLocalListLocale) {
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Computed Properties
    /// The image name to display based on the current theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "warning_dark" : "warning_light"
    }
    
    var body: some View {
        VStack() {
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
