import SwiftUI

struct DictionaryRemoteRowViewMetadata: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "graduationcap")
                    .font(.system(size: 11))
                    .foregroundColor(style.accentColor)

                Text(model.level)
                    .font(style.wordCountFont)
                    .foregroundColor(style.subtitleColor)
            }

            HStack(spacing: 4) {
                Image(systemName: "book")
                    .font(.system(size: 11))
                    .foregroundColor(style.accentColor)

                Text(model.formattedWordCount)
                    .font(style.wordCountFont)
                    .foregroundColor(style.subtitleColor)
            }
        }
    }
}
