import SwiftUI

/// Базовый экран игры, который отвечает за запуск/остановку игры, показ уведомлений и трекинг.
struct BaseGameScreen<Content: View>: View {
    // MARK: - Environment Objects и сервисы
    @EnvironmentObject private var localeManager: LocaleManager
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss

    // MARK: - Приватные свойства
    private let content: Content
    private let style: BaseGameScreenStyle
    private let game: any AbstractGame
    private let screen: ScreenType

    // MARK: - Состояние игры
    @ObservedObject private var gameState: GameState

    // MARK: - Инициализация
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
        ZStack {
            // Основной контент игры
            content
                .background(themeManager.currentThemeStyle.backgroundPrimary)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationBarHidden(gameState.showResults || gameState.showNoWords)
            
            // Результаты игры показываем как модальное окно
            if gameState.showResults {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                GameResult(stats: game.stats)
                    .environmentObject(gameState)
                    .transition(.opacity)
                    .zIndex(10)
            }
            
            // "Нет слов" показываем как обычное наложение
            if gameState.showNoWords {
                // Основной фон игры
                themeManager.currentThemeStyle.backgroundPrimary
                    .ignoresSafeArea()
                
                // Содержимое GameNoWords
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
