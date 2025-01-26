import SwiftUI

struct DictionaryImportViewExamples: View {
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
                title: locale.examplesTitle.uppercased(),
                style: .titled(ThemeManager.shared.currentThemeStyle)
            )
            
            VStack(alignment: .leading, spacing: 16) {
                exampleSection(
                    title: locale.commaSeparatedTitle,
                    examples: [
                        "cat,חתול,animal,household pet",
                        "cat,חתול,,household pet",
                        "cat,חתול,animal"
                    ]
                )
                
                Divider()
                
                exampleSection(
                    title: locale.semicolonSeparatedTitle,
                    examples: [
                        "sun;שמש;sky;the main star",
                        "sun;שמש;sky",
                        "sun;שמש;;the main star"
                    ]
                )
                
                Divider()
                
                exampleSection(
                    title: locale.verticalBarSeparatedTitle,
                    examples: [
                        "sea|ים|water|large body of water",
                        "sea|ים||large body of water",
                        "sea|ים|water|"
                    ]
                )
                
                Divider()
                
                exampleSection(
                    title: locale.tabSeparatedTitle,
                    examples: []
                )
            }
            .padding(.vertical, 8)
        }
    }
    
    private func exampleSection(title: String, examples: [String]) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.textSecondary)
            
            ForEach(examples, id: \.self) { example in
                Text(example)
                    .font(.system(size: 14, design: .monospaced))
            }
        }
    }
}
