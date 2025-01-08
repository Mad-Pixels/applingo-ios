import SwiftUI

struct BaseViewScreenPreview<Content: View>: View {
    let style: BaseViewScreenStyle
    let content: Content
    let screen: ScreenType
    let theme: ThemeType
   
    init(
        theme: ThemeType = .light,
        style: BaseViewScreenStyle = .default,
        screen: ScreenType,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.screen = screen
        self.content = content()
        ThemeManager.shared.setTheme(to: theme)
    }
    
    var body: some View {
        content
            .id(theme)
            .preferredColorScheme(theme == .dark ? .dark : .light)
            .environmentObject(ThemeManager.shared)
            .withScreenTracker(screen)
            .withLanguageTracker()
            .withThemeTracker()
    }
}

#Preview("Light Theme") {
    BaseViewScreenPreview(theme: .light, screen: .settings) {
        BaseViewScreen(screen: .settings) {
            VStack(spacing: 20) {
                Text("Content Example")
                Button("Action Button") {
                    // action
                }
            }
        }
    }
}

#Preview("Dark Theme") {
    BaseViewScreenPreview(theme: .dark, screen: .words) {
        BaseViewScreen(screen: .words) {
            VStack(spacing: 20) {
                Text("Content Example")
                Button("Action Button") {
                    // action
                }
            }
        }
    }
}
