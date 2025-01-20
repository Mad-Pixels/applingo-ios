import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let style: BaseGameScreenStyle
    private let screen: ScreenType
    private let content: Content
    
    init(
        screen: ScreenType,
        style: BaseGameScreenStyle = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
    }
    
    var body: some View {
        NavigationView {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .withScreenTracker(screen)
                .withErrorTracker(screen)
                .withLocaleTracker()
                .withThemeTracker()
        }
        .navigationViewStyle(.stack)
        .navigationBarColor(color: .clear)
    }
}
