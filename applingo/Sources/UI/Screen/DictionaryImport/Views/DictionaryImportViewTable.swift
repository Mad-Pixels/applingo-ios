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
                
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(style.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 16)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
