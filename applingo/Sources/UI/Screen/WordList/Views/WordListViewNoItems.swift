import SwiftUI

internal struct WordListViewNoItems: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: WordListLocale
    private let style: WordListStyle

    /// Initializes the WordListViewNoItems.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    init(style: WordListStyle, locale: WordListLocale) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack {
            Image(warningImageName)
                .resizable()
                .scaledToFit()
                .frame(width: style.iconSize, height: style.iconSize)
            
            DynamicText(
                model: DynamicTextModel(text: locale.screenNoWords),
                style: .headerMain(
                    ThemeManager.shared.currentThemeStyle,
                    alignment: .center,
                    lineLimit: 2
                )
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// Select image based on active theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "not_found" : "not_found"
    }
}
