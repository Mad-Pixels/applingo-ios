import SwiftUI

struct DictionaryRemoteRowViewSubcategory: View {
    let model: DictionaryRemoteRowModel
    let style: DictionaryRemoteRowStyle

    var body: some View {
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
            Text(model.subtitle)
                .font(style.subtitleFont)
                .foregroundColor(style.subtitleColor)
        }
    }
}
