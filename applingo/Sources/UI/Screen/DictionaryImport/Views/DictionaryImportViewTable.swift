import SwiftUI

/// A view that displays a table section in the dictionary import screen.
struct DictionaryImportViewTable: View {
    
    // MARK: - Properties
    
    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle
    
    // MARK: - Initializer
    
    init(locale: DictionaryImportLocale, style: DictionaryImportStyle) {
        self.locale = locale
        self.style = style
    }
    
    // MARK: - Body
    
    var body: some View {
        SectionBody {
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                SectionHeader(
                    title: locale.screenSubtitleCreateTable,
                    style: .heading(ThemeManager.shared.currentThemeStyle)
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
