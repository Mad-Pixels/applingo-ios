import SwiftUI

struct BaseViewTabPreview<Content: View>: View {
    let style: BaseViewTabStyle
    let theme: DiscoverTheme
    let content: Content
   
    init(
        theme: DiscoverTheme = .light,
        style: BaseViewTabStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content()
        
        ThemeManager.shared.setTheme(to: theme)
        BaseViewTabConfigurator.configure(
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
    BaseViewTabPreview(theme: .light, style: .default) {
        BaseViewTab() {
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
    BaseViewTabPreview(theme: .dark, style: .default) {
        BaseViewTab() {
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
