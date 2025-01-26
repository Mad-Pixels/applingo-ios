import SwiftUI

struct DictionaryImportViewNote: View {
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
                Text(locale.tableBody)
                    .padding(.top, 4)
                    .padding(.leading, 4)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
