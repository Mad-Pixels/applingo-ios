import SwiftUI

struct CompWordRowView: View {
    let word: WordItemModel
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(word.frontText)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.baseTextColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(BaseTextStyle())
            ZStack {
                Capsule()
                    .fill(ThemeManager.shared.currentThemeStyle.accentColor.opacity(0.1))
                    .frame(width: 36, height: 24)
                
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(ThemeManager.shared.currentThemeStyle.accentColor)
            }
            Text(word.backText)
                .font(.subheadline)
                .foregroundColor(ThemeManager.shared.currentThemeStyle.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .modifier(BaseTextStyle())
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}
