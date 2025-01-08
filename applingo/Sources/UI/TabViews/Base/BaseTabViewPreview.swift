import SwiftUI

struct BaseTabViewPreview<Content: View>: View {
    let style: TabViewBaseStyle
    let theme: ThemeType
    let content: Content
   
    init(
        theme: ThemeType = .light,
        style: TabViewBaseStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content()
        
        ThemeManager.shared.setTheme(to: theme)
        BaseTabViewConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
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
    BaseTabViewPreview(theme: .light, style: .default) {
        BaseTabView() {
            TabView {
                Group {
                    Text("Words")
                        .tabItem {
                            Label("Words", systemImage: "book.fill")
                        }
                    Text("Settings")
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    Text("Learn")
                        .tabItem {
                            Label("Learn", systemImage: "graduationcap.fill")
                        }
                }
            }
        }
    }
}

#Preview("Dark Theme") {
    BaseTabViewPreview(theme: .dark, style: .default) {
        BaseTabView() {
            TabView {
                Group {
                    Text("Words")
                        .tabItem {
                            Label("Words", systemImage: "book.fill")
                        }
                    Text("Settings")
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    Text("Learn")
                        .tabItem {
                            Label("Learn", systemImage: "graduationcap.fill")
                        }
                }
            }
        }
    }
}
