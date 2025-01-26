import SwiftUI

struct DictionaryImportViewColumns: View {
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
        VStack(alignment: .leading, spacing: style.sectionSpacing) {
            SectionHeader(
                title: locale.columnsTitle.uppercased(),
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            
            Text(locale.warningTitle)
                .font(.footnote)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.error)
                .padding(.top, 4)
                .padding(.leading, 4)
        }
    }
}
