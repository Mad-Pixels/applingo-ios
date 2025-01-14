import SwiftUI

struct WordRow: View {
    let word: WordRowModel
    let style: WordRowStyle
    let onTap: () -> Void
    
    init(
        word: WordRowModel,
        style: WordRowStyle = .themed(ThemeManager.shared.currentThemeStyle),
        onTap: @escaping () -> Void
    ) {
        self.word = word
        self.style = style
        self.onTap = onTap
    }
    
    var body: some View {
        HStack(spacing: style.spacing) {
            VStack(alignment: .leading, spacing: style.spacing / 2) {
                // Front text
                Text(word.frontText)
                    .foregroundColor(style.frontTextColor)
                    .font(style.frontTextFont)
                
                // Back text
                Text(word.backText)
                    .font(style.backTextFont)
                    .foregroundColor(style.backTextColor)
                
                // Progress indicator
                ChartIndicator(weight: word.weight)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // Arrow icon
            Image(systemName: "chevron.right")
                .font(.system(size: style.arrowSize))
                .foregroundColor(style.arrowColor)
        }
        .padding(.horizontal, style.spacing)
        .padding(.vertical, style.spacing * 0.75)
        .background(
            RoundedRectangle(cornerRadius: style.cornerRadius)
                .fill(style.backgroundColor)
                .shadow(
                    color: style.arrowColor.opacity(0.1),
                    radius: style.shadowRadius,
                    x: 0,
                    y: 2
                )
        )
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
