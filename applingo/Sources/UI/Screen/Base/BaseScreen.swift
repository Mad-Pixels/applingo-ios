import SwiftUI

struct BaseScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseScreenStyle
    private let screen: ScreenType
    private let content: Content
    
    init(
        screen: ScreenType,
        style: BaseScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
        
        BaseNavigationConfigurator.configure(
            with: ThemeManager.shared.currentThemeStyle,
            style: style
        )
    }
    
    var body: some View {
        NavigationView {
            content
                .id("\(themeManager.currentTheme.rawValue)_\(localeManager.viewId)")
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .withScreenTracker(screen)
                .withErrorTracker(screen)
                .withLocaleTracker()
                .withThemeTracker()
        }
        .onChange(of: themeManager.currentTheme) { _ in
            BaseNavigationConfigurator.configure(
                with: themeManager.currentThemeStyle,
                style: style
            )
        }
    }
}
