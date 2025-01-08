import SwiftUI

struct BaseViewTab<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseViewTabStyle
    private let content: Content
    
    init(
        style: BaseViewTabStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.content = content()
        BaseViewTabConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        content
            .withThemeTracker()
            .onChange(of: themeManager.currentTheme) { _ in
                BaseViewTabConfigurator.configure(
                    with: themeManager.currentThemeStyle,
                    style: style
                )
            }
    }
}
