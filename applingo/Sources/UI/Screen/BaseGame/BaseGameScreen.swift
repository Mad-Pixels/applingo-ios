import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    private let content: Content
    
    private let style: BaseGameScreenStyle
    private let game: any AbstractGame
    private let screen: ScreenType
    
    init(
        screen: ScreenType,
        game: any AbstractGame,
        @ViewBuilder content: () -> Content,
        style: BaseGameScreenStyle = .default
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
        self.game = game
    }
    
    var body: some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .withScreenTracker(screen)
            .withErrorTracker(screen)
            .withLocaleTracker()
            .withThemeTracker()
    }
}
