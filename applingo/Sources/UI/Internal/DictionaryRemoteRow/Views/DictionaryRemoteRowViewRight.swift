import SwiftUI

struct DictionaryRemoteRowViewRight: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let pair = model.languagePair {
                HStack(spacing: 4) {
                    FlagIcon(code: pair.from,
                             style: .themed(ThemeManager.shared.currentThemeStyle))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 11))
                        .foregroundColor(style.subtitleColor)
                    FlagIcon(code: pair.to,
                             style: .themed(ThemeManager.shared.currentThemeStyle))
                }
            } else {
                HStack(spacing: 4) {
                    Text(model.subtitle)
                        .font(style.subtitleFont)
                        .foregroundColor(style.subtitleColor)
                }
            }
            
            HStack(spacing: 4) {
                Image(systemName: "graduationcap")
                    .font(.system(size: 11))
                    .foregroundColor(style.accentColor)

                Text(model.level)
                    .font(style.wordCountFont)
                    .foregroundColor(style.subtitleColor)
            }
            .padding(.top, 4)
        }
    }
}
