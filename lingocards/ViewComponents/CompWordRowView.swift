import SwiftUI

struct CompWordRowView: View {
    let word: WordItem
    let onTap: () -> Void
    let theme: ThemeStyle

    var body: some View {
        HStack {
            Text(word.frontText)
                .foregroundColor(theme.baseTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(BaseTextStyle(theme: theme))
            Image(systemName: "arrow.left.and.right")
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(MainIconStyle(theme: theme))
            Text(word.backText)
                .font(.subheadline)
                .foregroundColor(theme.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .modifier(BaseTextStyle(theme: theme))
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
