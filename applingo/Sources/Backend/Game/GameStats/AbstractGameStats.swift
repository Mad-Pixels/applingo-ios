import SwiftUI

/// A protocol that defines the required properties and methods for tracking and updating game statistics.
/// Types conforming to `AbstractGameStats` should maintain metrics such as score, accuracy,
/// perfect streaks, and average response time, and provide a mechanism to update these values based on game events.
protocol AbstractGameStats {
    /// The player's accuracy, typically represented as a percentage.
    var accuracy: Double { get set }
    /// The number of consecutive correct answers (streaks/combo).
    var streaks: Int { get set }
    /// Score from the last answer.
    var score: GameScoringScoreAnswerModel { get set }
    /// The average time taken by the player to respond, measured in seconds.
    var averageResponseTime: TimeInterval { get set }
    /// Total average time taken by the player to respond during the game.
    var totalAverageResponseTime: TimeInterval { get set }
    /// The total answers count.
    var totalAnswers: Int { get set }
    /// The current game total score.
    var totalScore: Int { get set }
    /// The correct answers count.
    var correctAnswers: Int { get set }
    
    /// Updates the game statistics based on whether an answer was correct, the response time, the scoring strategy, and if a special card was used.
    ///
    /// - Parameters:
    ///   - correct: A Boolean indicating if the answer was correct.
    ///   - responseTime: The time taken to answer.
    ///   - scoring: An instance conforming to `AbstractGameScoring` that determines how score changes are calculated.
    ///   - isSpecialCard: A Boolean indicating if a special card was involved in the answer.
    func updateGameStats(correct: Bool, responseTime: TimeInterval, scoring: AbstractGameScoring, isSpecialCard: Bool)
}
