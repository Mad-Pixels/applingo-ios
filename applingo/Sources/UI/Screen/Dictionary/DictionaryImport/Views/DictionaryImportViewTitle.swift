import SwiftUI

internal struct DictionaryImportViewTitle: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle

    /// Initializes the WordDetailsViewStatistic.
    /// - Parameters:
    ///   - style: The style configuration.
    ///   - locale: The localization object.
    init(style: DictionaryImportStyle, locale: DictionaryImportLocale) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionBody {
            VStack(alignment: .center, spacing: style.sectionSpacing) {
                Image("import_title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                DynamicText(
                    model: DynamicTextModel(text: locale.screenSubtitleDictionaryAdd),
                    style: .headerGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 1
                    )
                )

                DynamicText(
                    model: DynamicTextModel(text: locale.screenTextDictionaryAdd),
                    style: .textBold(
                        themeManager.currentThemeStyle,
                        alignment: .center,
                        lineLimit: 4
                    )
                )
            }
            .padding(8)
        }
    }
}
