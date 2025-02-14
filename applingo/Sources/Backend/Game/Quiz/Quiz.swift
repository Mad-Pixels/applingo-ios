import SwiftUI

// MARK: - Quiz

/// A quiz game class that implements game logic, answer validation, score calculation, and cache management.
final class Quiz: ObservableObject, AbstractGame {
    // MARK: - Properties
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    internal let type: GameType = .quiz
    
    internal let validation: AbstractGameValidation
    internal let scoring: AbstractGameScoring
    internal let cache: QuizCache
    internal let theme: GameTheme
    
    internal var isReadyToPlay: Bool {
        true
    }
    private var gameTimer: GameStateUtilsTimer?
    
    @Published private(set) var statsObject = BaseGameStats()
    var stats: AbstractGameStats { statsObject }
    private(set) var state: GameState
    
    /// Dependency Injection initializer.
    /// - Parameters:
    ///   - theme: The game theme. Defaults to the current quiz theme.
    ///   - scoring: The scoring strategy. Defaults to a BaseGameScoring instance.
    ///   - validation: The validation strategy. Defaults to a QuizValidation instance.
    ///   - cacheGetter: The cache manager. Defaults to a QuizCache instance.
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.quizTheme,
        scoring: AbstractGameScoring = BaseGameScoring(
            baseScore: 8,
            quickResponseThreshold: 0.6,
            quickResponseBonus: 5,
            specialCardBonus: 20
        ),
        validation: any AbstractGameValidation = QuizValidation(
            feedbacks: [.incorrect: IncorrectAnswerHapticFeedback()]
        ),
        cacheGetter: QuizCache = QuizCache(cacheSize: 50, threshold: 10)
    ) {
        self.theme = theme
        self.scoring = scoring
        self.validation = validation
        self.cache = cacheGetter
        
        self.state = GameState()
        self.statsObject = BaseGameStats(game: self)
    }
    
    /// Creates and returns the game view with the cache manager injected as an EnvironmentObject.
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameQuiz(game: self)
                .environmentObject(cache)
        )
    }
    
    // MARK: - Internal Methods
    /// Validates the user's answer and returns the result.
    /// - Parameter answer: The user's answer as a String.
    /// - Returns: A GameValidationResult indicating whether the answer is correct.
    internal func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result)
        return result
    }
    
    /// Updates the game statistics based on the answer correctness, response time, and if a special card was used.
    /// - Parameters:
    ///   - correct: A Boolean indicating if the answer was correct.
    ///   - responseTime: The time taken to answer.
    ///   - isSpecialCard: A Boolean indicating if a special card was used.
    internal func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        statsObject.updateGameStats(
            correct: correct,
            responseTime: responseTime,
            scoring: scoring,
            isSpecialCard: isSpecialCard
        )
    }
    
    /// Returns a game mode model for the specified mode.
    /// - Parameter type: The game mode type.
    /// - Returns: A GameModeModel corresponding to the given mode.
    internal func getModeModel(_ type: GameModeType) -> GameModeModel {
        switch type {
        case .practice:
            return .practice(locale: GameModeLocale())
        case .survival:
            return .survival(locale: GameModeLocale())
        case .time:
            return .time(locale: GameModeLocale())
        }
    }
    
    // MARK: - Invoke Methods
    /// Starts the game with the given mode.
    /// - Parameter mode: The selected game mode.
    func start(mode: GameModeType) {
        state.survivalState = nil
        state.timeState = nil
        
        state.currentMode = mode
        state.isGameOver = false
        cache.initialize()
        
        switch mode {
            case .survival:
                state.survivalState = GameState.SurvivalState(lives: 3)
            case .time:
                let timer = GameStateUtilsTimer(duration: 120)
                timer.onTimeUp = { [weak self] in
                    self?.endGame(reason: .timeUp)
                }
                timer.start()
                state.timeState = timer
            case .practice:
                break
        }
    }
    
///
    enum GameEndReason {
            case timeUp
            case noLives
            case userQuit
        }
    
    private func endGame(reason: GameEndReason) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Останавливаем таймер
                if case .time = self.state.currentMode {
                    self.state.timeState?.stop()
                }
                
                self.state.isGameOver = true
                
                Logger.debug("[Quiz]: Game ended", metadata: [
                    "reason": String(describing: reason),
                    "finalScore": String(self.statsObject.score)
                ])
            }
        }
///
    
    /// Ends the game and clears the cache.
    func end() {
        endGame(reason: .userQuit)
        cache.clear()
    }
}
