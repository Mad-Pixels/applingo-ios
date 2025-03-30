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
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                Image("import_title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                SectionHeader(
                    title: locale.screenSubtitleDictionaryAdd,
                    style: .block(ThemeManager.shared.currentThemeStyle)
                )
                
                DynamicText(
                    model: DynamicTextModel(text: locale.screenTextDictionaryAdd),
                    style: .textMain(themeManager.currentThemeStyle)
                )
                .padding(.top, -8)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
