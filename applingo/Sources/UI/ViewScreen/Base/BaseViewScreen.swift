import SwiftUI

struct BaseViewScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseViewScreenStyle
    private let screen: ScreenType
    private let content: Content
    
    init(
        screen: ScreenType,
        style: BaseViewScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
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
    }
}
