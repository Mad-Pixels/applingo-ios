import SwiftUI

internal struct DictionaryImportViewTable: View {
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
                SectionHeader(
                    title: locale.screenSubtitleCreateTable,
                    style: .block(ThemeManager.shared.currentThemeStyle)
                )
                
                Image(ThemeManager.shared.currentTheme.asString == "Dark" ? "table_example_dark" : "table_example_light")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 320, height: 95)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
