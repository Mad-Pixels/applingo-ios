import SwiftUI

struct BaseViewScreen<Content: View>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseViewScreenStyle
    private let screen: ScreenType
    private let content: Content
    
    init(
        screen: ScreenType,
        style: BaseViewScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.screen = screen
        self.style = style
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            content
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .withScreenTracker(screen)
                .withLocaleTracker()
                .withThemeTracker()
        }
    }
}
