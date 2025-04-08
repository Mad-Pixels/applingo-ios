import SwiftUI

internal struct DictionaryRemoteListViewNoItems: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let locale: DictionaryRemoteListLocale
    private let style: DictionaryRemoteListStyle
    
    /// Initializes the WordListViewWelcome.
    /// - Parameters:
    ///   - style: `DictionaryRemoteListStyle` object that defines the visual style.
    ///   - locale: `DictionaryRemoteListLocale` object that provides localized strings.
    init(style: DictionaryRemoteListStyle, locale: DictionaryRemoteListLocale) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        VStack() {
            Image(warningImageName)
                .resizable()
                .scaledToFit()
                .frame(width: style.iconSize, height: style.iconSize)

            DynamicText(
                model: DynamicTextModel(text: locale.screenNoWords),
                style: .headerMain(
                    themeManager.currentThemeStyle,
                    alignment: .center,
                    lineLimit: 1
                )
            )
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    /// The image name to display based on the current theme.
    private var warningImageName: String {
        themeManager.currentTheme.asString == "Dark" ? "not_found" : "not_found"
    }
}
