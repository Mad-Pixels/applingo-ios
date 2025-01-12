import SwiftUI

struct BaseTab<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseTabStyle
    private let content: Content
    
    init(
        style: BaseTabStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
        BaseTabConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        content
            .withThemeTracker()
            .onChange(of: themeManager.currentTheme) { _ in
                BaseTabConfigurator.configure(
                    with: themeManager.currentThemeStyle,
                    style: style
                )
            }
    }
}
