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
                Image("import_title")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 125)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                SectionHeader(
                    title: locale.screenSubtitleDictionaryAdd,
                    style: .block(ThemeManager.shared.currentThemeStyle)
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
