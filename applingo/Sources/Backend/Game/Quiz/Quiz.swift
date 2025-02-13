import SwiftUI

// MARK: - Quiz

/// A quiz game class that implements game logic, answer validation, score calculation, and cache management.
final class Quiz: ObservableObject, AbstractGame {
    /// The type used for validation answers.
    typealias ValidationAnswer = String
    
    let validation: any AbstractGameValidation
    let theme: GameTheme
    let type: GameType = .quiz
    let availableModes: [GameModeType] = [.practice, .survival, .time]
    let scoring: AbstractGameScoring
    
    /// The quiz cache manager, initialized with a cache size of 10 and a threshold of 6.
    private(set) var cacheGetter: QuizCache = QuizCache(cacheSize: 10, threshold: 6)
    
    /// The game statistics object.
    @Published private(set) var statsObject = BaseGameStats()
    var stats: any AbstractGameStats { statsObject }
    
    private(set) lazy var state: GameState = {
        GameState(stats: stats)
    }()
    
    init() {
        self.theme = ThemeManager.shared.currentThemeStyle.quizTheme
        self.scoring = BaseGameScoring(
            baseScore: 8,
            quickResponseThreshold: 0.6,
            quickResponseBonus: 5,
            specialCardBonus: 15
        )
        self.validation = QuizValidation(
            feedbacks: [
                .correct: CorrectAnswerHapticFeedback()
            ]
        )
    }
    
    /// Creates and returns the game view with the cache manager injected as an EnvironmentObject.
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameQuiz(game: self)
                .environmentObject(cacheGetter)
        )
    }
    
    /// Indicates whether the game is ready to play.
    var isReadyToPlay: Bool {
        true
    }
    
    /// Validates the user's answer and returns the result.
    /// - Parameter answer: The user's answer as a String.
    /// - Returns: A GameValidationResult indicating whether the answer is correct.
    func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result)
        return result
    }
    
    /// Updates the game statistics based on the answer correctness, response time, and if a special card was used.
    /// - Parameters:
    ///   - correct: A Boolean indicating if the answer was correct.
    ///   - responseTime: The time taken to answer.
    ///   - isSpecialCard: A Boolean indicating if a special card was used.
    func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        if correct {
            let points = scoring.calculateScore(
                responseTime: responseTime,
                isSpecialCard: isSpecialCard
            )
            Logger.debug("[Quiz]: Adding points: \(points), current score: \(statsObject.score)")
            statsObject.score += points
            Logger.debug("[Quiz]: New score: \(statsObject.score)")
        } else {
            let penalty = scoring.calculatePenalty()
            Logger.debug("[Quiz]: Subtracting penalty: \(penalty), current score: \(statsObject.score)")
            statsObject.score -= penalty
            Logger.debug("[Quiz]: New score: \(statsObject.score)")
        }
    }
    
    /// Returns a game mode model for the specified mode.
    /// - Parameter type: The game mode type.
    /// - Returns: A GameModeModel corresponding to the given mode.
    func getModeModel(_ type: GameModeType) -> GameModeModel {
        switch type {
        case .practice:
            return .practice(locale: GameModeLocale())
        case .survival:
            return .survival(locale: GameModeLocale())
        case .time:
            return .time(locale: GameModeLocale())
        }
    }
    
    /// Starts the game with the given mode.
    /// - Parameter mode: The selected game mode.
    func start(mode: GameModeType) {
        state.currentMode = mode
        cacheGetter.initializeCache()
        
        switch mode {
        case .survival:
            state.survivalState = GameState.SurvivalState(lives: 3)
        case .time:
            state.timeState = GameState.TimeState(timeLeft: 120)
        case .practice:
            break
        }
    }
    
    /// Ends the game and clears the cache.
    func end() {
        cacheGetter.clearCache()
    }
}
