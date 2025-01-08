import SwiftUI

struct AppViewTab<Content: View>: View {
    let content: () -> Content
    let theme: DisplayTheme
    let style: BaseViewTabStyle
    
    init(
        theme: DisplayTheme = .light,
        style: BaseViewTabStyle = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content

        BaseViewTabConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }

    var body: some View {
        BaseViewTab(style: style) {
            content()
        }
    }
}
