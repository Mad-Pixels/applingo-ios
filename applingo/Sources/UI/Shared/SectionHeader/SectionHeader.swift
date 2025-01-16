import SwiftUI

struct SectionHeader: View {
    let title: String
    let style: SectionHeaderStyle
    
    init(
        title: String,
        style: SectionHeaderStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        self.title = title
        self.style = style
    }
    
    var body: some View {
        VStack(spacing: style.spacing) {
            Text(title)
                .font(style.titleFont)
                .foregroundColor(style.titleColor)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, style.padding.leading)
            
            Rectangle()
                .fill(style.separatorColor)
                .frame(height: 0.5)
        }
    }
}
