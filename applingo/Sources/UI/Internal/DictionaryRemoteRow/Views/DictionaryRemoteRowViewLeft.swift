import SwiftUI

struct DictionaryRemoteRowViewLeft: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle

    var body: some View {
        Text(model.title)
            .font(style.titleFont)
            .foregroundColor(style.titleColor)
        
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

            Text(verbatim: "\(model.rating)")
                .font(style.wordCountFont)
                .foregroundColor(style.subtitleColor)
        }
    }
}
