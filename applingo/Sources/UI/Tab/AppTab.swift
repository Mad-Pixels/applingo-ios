import SwiftUI

/// A container view that applies a base tab style and theme.
struct AppTab<Content: View>: View {
    let content: () -> Content
    let style: BaseTabStyle

    /// Initializes the AppTab.
    /// - Parameters:
    ///   - theme: The current theme type. Defaults to .light.
    ///   - style: The base tab style. Defaults to .default.
    ///   - content: A view builder for the tab content.
    init(
        style: BaseTabStyle = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.content = content

        BaseTabConfigurator.configure(with: ThemeManager.shared.currentThemeStyle, style: style)
    }

    var body: some View {
        BaseTab(style: style) {
            content()
        }
    }
}
