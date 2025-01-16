import SwiftUI

struct SectionBody<Content: View>: View {
    let style: SectionBodyStyle
    let content: Content
    
    init(
        style: SectionBodyStyle = .themed(ThemeManager.shared.currentThemeStyle),
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(.horizontal, style.padding.leading)
            .padding(.vertical, style.padding.top)
            .background(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .fill(style.backgroundColor)
                    .shadow(
                        color: style.shadowColor.opacity(0.1),
                        radius: style.shadowRadius,
                        x: 0,
                        y: 2
                    )
            )
    }
}
