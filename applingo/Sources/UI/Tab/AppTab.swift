import SwiftUI

struct AppTab<Content: View>: View {
    let content: () -> Content
    let theme: ThemeType
    let style: BaseTabStyle
    
    init(
        theme: ThemeType = .light,
        style: BaseTabStyle = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content

        BaseTabConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }

    var body: some View {
        BaseTab(style: style) {
            content()
        }
    }
}
