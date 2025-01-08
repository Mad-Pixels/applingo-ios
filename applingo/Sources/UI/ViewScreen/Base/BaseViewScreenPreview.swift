import SwiftUI

struct BaseViewScreenPreview<Content: View>: View {
    let style: BaseViewScreenStyle
    let theme: DiscoverTheme
    let content: Content
   
    init(
        theme: DiscoverTheme = .light,
        style: BaseViewScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content()
        ThemeManager.shared.setTheme(to: theme)
    }
    
    var body: some View {
        content
            .id(theme)
            .preferredColorScheme(theme == .dark ? .dark : .light)
            .environmentObject(ThemeManager.shared)
            .withThemeTracker()
    }
}

#Preview("Light Theme") {
    BaseViewScreenPreview(theme: .light) {
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
    BaseViewScreenPreview(theme: .dark) {
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
