import SwiftUI

internal struct DictionaryRemoteRowViewLeft: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    internal let model: DictionaryRemoteRowModel
    internal let style: DictionaryRemoteRowStyle

    var body: some View {
        DynamicTextCompact(
            model: DynamicTextModel(text: model.title),
            style: .textBold(
                themeManager.currentThemeStyle,
                lineLimit: 6
            )
        )
        
        HStack(spacing: 4) {
            Image(systemName: "book")
                .font(.system(size: 11))
                .foregroundColor(style.accentColor)

            Text(model.formattedWordCount)
                .font(style.wordCountFont)
                .foregroundColor(style.subtitleColor)
        }
        
        HStack(spacing: 4) {
            Image(systemName: "icloud.and.arrow.down")
                .font(.system(size: 11))
                .foregroundColor(style.accentColor)

            Text(verbatim: "\(model.downloads)")
                .font(style.wordCountFont)
                .foregroundColor(style.subtitleColor)
        }
    }
}
