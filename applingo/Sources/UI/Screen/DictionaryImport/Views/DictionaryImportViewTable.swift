import SwiftUI

struct DictionaryImportViewTable: View {
    private let locale: DictionaryImportLocale
    private let style: DictionaryImportStyle
    
    init(
        locale: DictionaryImportLocale,
        style: DictionaryImportStyle
    ) {
        self.locale = locale
        self.style = style
    }
    
    var body: some View {
        SectionBody {
            VStack(alignment: .leading, spacing: style.sectionSpacing) {
                SectionHeader(
                    title: locale.tableHeader.uppercased(),
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
