import SwiftUI

struct DictionaryRemoteListViewNoItems: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle
    
    // MARK: - Initializer
    /// Initializes a new instance of `WordListViewWelcome`.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    init(style: DictionaryRemoteListStyle, locale: DictionaryRemoteListLocale) {
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
