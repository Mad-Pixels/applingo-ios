import SwiftUI

struct CompWordRowView: View {
    let word: WordItem
    let onTap: () -> Void
    let theme: ThemeStyle

    var body: some View {
        HStack {
            Text(word.frontText)
                .modifier(TitleTextStyle(theme: theme))

            Image(systemName: "arrow.left.and.right.circle.fill")
                .foregroundColor(theme.primaryButtonColor)

            Text(word.backText)
                .modifier(SubtitleTextStyle(theme: theme))
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
