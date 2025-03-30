import SwiftUI

struct BaseGameScreen<Content: View>: View {
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var gameState: GameState

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
        self.gameState = game.state
    }

    var body: some View {
        ZStack {
            content
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(gameState.showResults || gameState.showNoWords)
            
            if gameState.showResults {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                GameResult(stats: game.stats)
                    .environmentObject(gameState)
                    .transition(.opacity)
                    .zIndex(10)
            }
            
            if gameState.showNoWords {
                themeManager.currentThemeStyle.backgroundPrimary
                    .ignoresSafeArea()
                
                GameNoWords()
                    .environmentObject(gameState)
                    .transition(.opacity)
                    .zIndex(5)
            }
        }
        .onReceive(gameState.$isGameOver) { isGameOver in
            if isGameOver, gameState.endReason == .userQuit {
                dismiss()
            }
        }
        .onAppear {
            game.start()
        }
        .onDisappear {
            game.end()
        }
        .withScreenTracker(screen)
        .withErrorTracker(screen)
        .withLocaleTracker()
        .withThemeTracker()
    }
}
