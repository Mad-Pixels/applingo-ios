import SwiftUI

// MARK: - SectionBody View
/// Wraps content in a styled container with padding, rounded background, and shadow.
struct SectionBody<Content: View>: View {
    let style: SectionBodyStyle
    let content: Content

    /// Initializes the SectionBody with a style and content.
    /// - Parameters:
    ///   - style: The style for the section body. Defaults to themed style using the current theme.
    ///   - content: A view builder for the content.
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
