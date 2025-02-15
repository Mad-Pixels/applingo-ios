import SwiftUI

/// A base class for managing game statistics, conforming to `AbstractGameStats`.
/// This class tracks key metrics such as score, accuracy, streaks, and average response time,
/// and provides a method to update these statistics based on the outcome of a game action.
/// The implementation ensures that the score never falls below zero.
final class BaseGameStats: ObservableObject, AbstractGameStats {
    // MARK: - Published Properties
    /// The player's accuracy as a percentage.
    @Published var accuracy: Double = 0
    /// The number of consecutive correct answers.
    @Published var streaks: Int = 0
    /// Score from the last answer.
    @Published var score: Int = 0
    /// The average time taken by the player to respond.
    @Published var averageResponseTime: TimeInterval = 0
    /// The total number of answers given.
    @Published var totalAnswers: Int = 0
    /// The current game score.
    @Published var totalScore: Int = 0
    /// Total average time taken by the player to respond during the game.
    @Published var totalAverageResponseTime: TimeInterval = 0
    /// The number of correct answers given.
    @Published var correctAnswers: Int = 0
    
    // MARK: - Private Properties
    /// A weak reference to the game, used to update survival state when applicable.
    private weak var game: Quiz?
    
    // MARK: - Initializer
    /// Initializes a new instance of `BaseGameStats`.
    ///
    /// - Parameter game: An optional instance of `Quiz` for survival mode updates.
    init(game: Quiz? = nil) {
        self.game = game
    }
    
    // MARK: - Internal Methods
    /// Updates the game statistics based on the correctness of the answer,
    /// the response time, the scoring mechanism, and whether a special card was used.
    ///
    /// For a correct answer, the score is increased based on the scoring strategy, and the streak is incremented.
    /// For an incorrect answer, a penalty is subtracted from the score (ensuring that it does not drop below zero),
    /// the streak is reset, and if the game is in survival mode, the survival state is updated.
    ///
    /// After processing the answer, the total answer count and accuracy are updated.
    ///
    /// - Parameters:
    ///   - correct: A Boolean indicating whether the answer was correct.
    ///   - responseTime: The time taken to provide the answer.
    ///   - scoring: An instance conforming to `AbstractGameScoring` used to compute score changes.
    ///   - isSpecialCard: A Boolean indicating if a special card was involved in the answer.
    final internal func updateGameStats(correct: Bool,
                                        responseTime: TimeInterval,
                                        scoring: AbstractGameScoring,
                                        isSpecialCard: Bool
    ) {
        if correct {
            streaks += 1
            totalScore += scoring.calculateScore(
                responseTime: responseTime,
                isSpecialCard: isSpecialCard,
                streaks: streaks
            )
            correctAnswers += 1
        } else {
            streaks = 0
            totalScore -= scoring.calculatePenalty()
            if totalScore < 0 {
                totalScore = 0
            }
            
            updateSurvivalState()
        }
        
        totalAnswers += 1
        accuracy = Double(correctAnswers) / Double(totalAnswers)
        
        Logger.debug("[GameStats]: Updated stats", metadata: [
            "totalScore": String(totalScore),
            "streak": String(streaks),
            "accuracy": String(format: "%.2f", accuracy),
            "correct": String(correct),
            "totalAnswers": String(totalAnswers)
        ])
    }
    
    // MARK: - Private Methods
    /// Updates the survival state if the game is in survival mode.
    ///
    /// This method decrements the number of lives in the survival state.
    /// If lives reach zero or below, it logs a game-over message and sets the game's `isGameOver` flag.
    private func updateSurvivalState() {
        if let game = game,
           game.state.currentMode == .survival,
           var survivalState = game.state.survivalState {
            survivalState.lives -= 1
            game.state.survivalState = survivalState
            
            if survivalState.lives <= 0 {
                Logger.debug("[GameStats]: Game over - no lives left")
                DispatchQueue.main.async {
                    game.state.isGameOver = true
                }
            }
        }
    }
}
