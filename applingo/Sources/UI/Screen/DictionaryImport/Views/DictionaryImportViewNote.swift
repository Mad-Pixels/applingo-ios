import SwiftUI

/// A view that displays a note section in the dictionary import screen.
struct DictionaryImportViewNote: View {
    
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
                Text(locale.tableBody)
                    .padding(.top, 4)
                    .padding(.leading, 4)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
