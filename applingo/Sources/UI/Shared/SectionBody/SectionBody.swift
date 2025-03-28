import SwiftUI

struct SectionBody<Content: View>: View {
    let style: SectionBodyStyle
    let content: Content

    /// Initializes the SectionBody.
    /// - Parameters:
    ///   - style: The styling for the body. Defaults to themed style using the current theme.
    ///   - content: A view builder for the content.
    init(
        @ViewBuilder content: () -> Content,
        style: SectionBodyStyle = .block(ThemeManager.shared.currentThemeStyle)
    ) {
        self.content = content()
        self.style = style
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
            .overlay(
                Group {
                    if let borderWidth = style.borderWidth,
                       let borderColor = style.borderColor
                    {
                        RoundedRectangle(cornerRadius: style.cornerRadius)
                            .stroke(borderColor, lineWidth: borderWidth)
                    }
                }
            )
    }
}
