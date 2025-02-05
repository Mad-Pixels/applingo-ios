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
                    title: locale.screenSubtitleDictionaryAdd,
                    style: .heading(ThemeManager.shared.currentThemeStyle)
                )
                
                Text(locale.screenTextDictionaryAdd)
                    .font(style.textFont)
                    .foregroundStyle(style.textColor)
                    .padding(.top, -8)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}
