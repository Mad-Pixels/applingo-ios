import SwiftUI

struct AppTabView<Content: View>: View {
    let content: () -> Content
    let theme: ThemeType
    let style: TabViewBaseStyle
    
    init(
        theme: ThemeType = .light,
        style: TabViewBaseStyle = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content

        BaseTabViewConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }

    var body: some View {
        BaseTabView {
            content()
                .id(theme)
                .preferredColorScheme(theme == .dark ? .dark : .light)
                .environmentObject(ThemeManager.shared)
                .withThemeTracker()
        }
    }
}
