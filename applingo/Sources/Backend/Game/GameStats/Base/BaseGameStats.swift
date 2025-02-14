import SwiftUI

/// A base class for managing game statistics, conforming to `AbstractGameStats`.
/// This class tracks key metrics such as score, accuracy, perfect streaks, and average response time.
/// It also provides a method to update these statistics based on the outcome of a game action.
/// The implementation ensures that the score never falls below zero.
final class BaseGameStats: ObservableObject, AbstractGameStats {
    // MARK: - Published Properties
    /// The current game score.
    @Published var score: Int = 0
    /// The player's accuracy as a percentage.
    @Published var accuracy: Double = 0
    /// The number of consecutive correct answers.
    @Published var streaks: Int = 0
    /// The average time taken by the player to respond.
    @Published var averageResponseTime: TimeInterval = 0
    
    // MARK: - Internal Methods
    /// Updates the game statistics based on the correctness of the answer,
    /// the response time, the scoring mechanism, and whether a special card was used.
    ///
    /// For a correct answer, the score is increased based on the scoring strategy, and the perfect streak is incremented.
    /// For an incorrect answer, a penalty is subtracted from the score (ensuring that it does not drop below zero)
    /// and the perfect streak is reset.
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
            score += scoring.calculateScore(
                responseTime: responseTime,
                isSpecialCard: isSpecialCard,
                streaks: streaks
            )
        } else {
            streaks = 0
            score -= scoring.calculatePenalty()
            if score < 0 {
                score = 0
            }
        }
        
        Logger.debug("[GameStats]: Updated stats for correct answer", metadata: [
            "score": String(score),
            "streak": String(streaks),
            "responseTime": String(responseTime)
        ])
    }
}
