import SwiftUI
import Combine

/// Базовый экран игры, который отвечает за запуск/остановку игры, показ модальных окон и трекинг.
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

    /// Замыкание для получения модального окна в зависимости от состояния игры.
    /// Если возвращается nil, модальное окно не показывается.
    private let modalContent: (GameState) -> AnyView?

    // MARK: - Инициализация
    init(
        screen: ScreenType,
        game: any AbstractGame,
        @ViewBuilder content: () -> Content,
        style: BaseGameScreenStyle = .default,
        modalContent: ((GameState) -> AnyView?)? = nil
    ) {
        self.content = content()
        self.screen = screen
        self.style = style
        self.game = game
        self.gameState = game.state
        // Если modalContent не передано, используем замыкание по умолчанию
        self.modalContent = modalContent ?? { state in
            if state.showNoWords {
                return AnyView(GameNoWords())
            } else if state.showResults {
                return AnyView(GameResult(stats: game.stats))
            } else {
                return nil
            }
        }
    }

    // MARK: - Body
    var body: some View {
        content
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Скрываем навигационную панель, если показывается модальное окно
            .navigationBarHidden(gameState.showResults || gameState.showNoWords)
            // Показываем модальное окно, если хотя бы одно из состояний истинно
            .showModal(isPresented: Binding<Bool>(
                get: {
                    gameState.showResults || gameState.showNoWords
                },
                set: { newValue in
                    if !newValue {
                        // При закрытии окна сбрасываем оба флага
                        gameState.showResults = false
                        gameState.showNoWords = false
                    }
                }
            )) {
                if let modal = modalContent(gameState) {
                    modal.environmentObject(gameState)
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
