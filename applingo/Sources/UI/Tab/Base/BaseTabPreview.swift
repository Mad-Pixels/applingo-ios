import SwiftUI

struct BaseViewTabPreview<Content: View>: View {
    let style: BaseTabStyle
    let theme: ThemeType
    let content: Content
   
    init(
        theme: ThemeType = .light,
        style: BaseTabStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content()
        
        ThemeManager.shared.setTheme(to: theme)
        BaseTabConfigurator.configure(
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
        BaseTab() {
            TabView {
                Text("Main")
                    .tabItem {
                        Label("Main", systemImage: "rectangle.grid.2x2.fill")
                    }
                Text("Words")
                    .tabItem {
                        Label("Words", systemImage: "text.magnifyingglass")
                    }
                Text("Dictionaries")
                    .tabItem {
                        Label("Dictionaries", systemImage: "doc.text.fill.viewfinder")
                    }
                Text("Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.2.fill")
                    }
            }
        }
    }
}

#Preview("Dark Theme") {
    BaseViewTabPreview(theme: .dark, style: .default) {
        BaseTab() {
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
