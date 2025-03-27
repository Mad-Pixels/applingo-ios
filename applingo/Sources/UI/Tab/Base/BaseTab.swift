import SwiftUI

/// Wraps content with theme tracking and applies the base tab style.
struct BaseTab<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let style: BaseTabStyle
    private let content: Content

    /// Initializes the BaseTab.
    /// - Parameters:
    ///   - style: The base tab style.
    ///   - content: A view builder for the tab content.
    init(
        style: BaseTabStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
        BaseTabConfigurator.configure(with: ThemeManager.shared.currentThemeStyle, style: style)
    }

    var body: some View {
        content
            .withThemeTracker()
            .onChange(of: themeManager.currentTheme) { _ in
                BaseTabConfigurator.configure(with: themeManager.currentThemeStyle, style: style)
            }
    }
}
