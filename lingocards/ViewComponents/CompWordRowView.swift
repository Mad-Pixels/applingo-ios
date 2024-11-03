import SwiftUI

struct CompWordRowView: View {
    let word: WordItemModel
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(word.frontText)
                .foregroundColor(ThemeManager().currentThemeStyle.baseTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(BaseTextStyle())
            Image(systemName: "arrow.left.and.right")
                .frame(maxWidth: .infinity, alignment: .center)
                .modifier(MainIconStyle())
            Text(word.backText)
                .font(.subheadline)
                .foregroundColor(ThemeManager().currentThemeStyle.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .modifier(BaseTextStyle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
