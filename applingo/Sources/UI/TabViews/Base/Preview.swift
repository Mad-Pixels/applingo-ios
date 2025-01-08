import SwiftUI

struct BasePreview<Content: View>: View {
    let content: Content
    let theme: ThemeType
    
    init(theme: ThemeType = .light, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
        ThemeManager.shared.setTheme(to: theme)
    }
    
    var body: some View {
        content
            .environmentObject(ThemeManager.shared)
            .environmentObject(LanguageManager.shared)
            .environmentObject(FrameManager.shared)
            .environmentObject(ErrorManager.shared)
            .withThemeTracker()
    }
}

#Preview("Tab View - Light") {
    BasePreview(theme: .light) {
        TabView {
            Text("Light Theme Content")
                .tabItem {
                    Label("Words", systemImage: "text.book.closed")
                }
        }
    }
}

#Preview("Tab View - Dark") {
    BasePreview(theme: .dark) {
        TabView {
            Text("Dark Theme Content")
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}
