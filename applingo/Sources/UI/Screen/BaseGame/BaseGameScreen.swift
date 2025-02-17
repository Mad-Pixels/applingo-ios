import SwiftUI
import Combine

/// The main game screen that wraps the content of a specific game view.
/// This view is responsible for starting and ending the game, showing modals,
/// and handling tracking for screens, errors, locales, and themes.
struct BaseGameScreen<Content: View>: View {
    // MARK: - Environment Objects and Services
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    // MARK: - Private Objects
    /// The content of the game screen, provided via a ViewBuilder.
    private let content: Content
    /// The style to apply to the game screen.
    private let style: BaseGameScreenStyle
    /// The game object conforming to `AbstractGame`.
    private let game: any AbstractGame
    /// The screen type used for tracking, logging, etc.
    private let screen: ScreenType

    // MARK: - Game State
    /// The observable game state.
    /// Using `@ObservedObject` ensures that any changes in the game state update the UI.
    @ObservedObject private var gameState: GameState

    // MARK: - Initialization
    /// Initializes the game screen.
    ///
    /// - Parameters:
    ///   - screen: The type of the screen for tracking purposes.
    ///   - game: The game object conforming to `AbstractGame`.
    ///   - content: A ViewBuilder closure that provides the content for the screen.
    ///   - style: The style for the game screen. Defaults to `.default`.
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

    // MARK: - Body
    var body: some View {
        content
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationBarHidden(gameState.showResults)
            .showModal(isPresented: $gameState.showResults) {
                GameResult()
                    .environmentObject(gameState)
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
