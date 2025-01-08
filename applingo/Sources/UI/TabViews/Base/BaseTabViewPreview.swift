import SwiftUI

struct BaseTabViewPreview<Content: View>: View {
    let content: Content
    let theme: ThemeType
    let style: TabViewBaseStyle
    
    init(
        theme: ThemeType = .light,
        style: TabViewBaseStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.style = style
        self.content = content()
        // Устанавливаем тему сразу при инициализации
        ThemeManager.shared.setTheme(to: theme)
        // Применяем конфигурацию таб-бара
        BaseTabViewConfigurator.configure(with: ThemeManager.shared.currentThemeStyle, style: style)
    }
    
    var body: some View {
        content
            .id(theme) // Форсируем обновление при смене темы
            .preferredColorScheme(theme == .dark ? .dark : .light)
            .environmentObject(ThemeManager.shared)
            .environmentObject(LanguageManager.shared)
            .environmentObject(FrameManager.shared)
            .environmentObject(ErrorManager.shared)
            .withFrameTracker(.learn)
            .withThemeTracker()
    }
}

#Preview("Tab View - Light") {
    BaseTabViewPreview(theme: .light, style: .default) {
        BaseTabView(frame: .main) {
            TabView {
                Text("Light Theme - Words")
                    .tabItem {
                        Label("Words", systemImage: "text.book.closed")
                    }
                Text("Light Theme - Dictionary")
                    .tabItem {
                        Label("Dictionary", systemImage: "folder.fill")
                    }
                Text("Light Theme - Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

#Preview("Tab View - Dark") {
    BaseTabViewPreview(theme: .dark, style: .default) {
        BaseTabView(frame: .main) {
            TabView {
                Text("Dark Theme - Words")
                    .tabItem {
                        Label("Words", systemImage: "text.book.closed")
                    }
                Text("Dark Theme - Dictionary")
                    .tabItem {
                        Label("Dictionary", systemImage: "folder.fill")
                    }
                Text("Dark Theme - Settings")
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}
