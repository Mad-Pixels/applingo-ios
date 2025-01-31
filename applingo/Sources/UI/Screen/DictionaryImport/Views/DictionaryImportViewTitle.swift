import SwiftUI

/// A view that displays the title section of the dictionary import screen.
struct DictionaryImportViewTitle: View {
    
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
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(style.accentColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 16)
                
                SectionHeader(
                    title: locale.titleHeader.uppercased(),
                    style: .heading(ThemeManager.shared.currentThemeStyle)
                )
                
                Text(locale.titleBody)
                    .padding(.top, 4)
                    .padding(.leading, 4)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
