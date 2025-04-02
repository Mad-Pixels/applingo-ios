import SwiftUI

final class GameStats: ObservableObject {
    /// The player's accuracy as a percentage.
    @Published var accuracy: Double = 0
    
    /// The number of consecutive correct answers.
    @Published var streaks: Int = 0
    
    /// The best streak of correct answers.
    @Published var correctAnswersStreak: Int = 0
    
    /// Score from the last answer.
    @Published var score: GameScoringScoreAnswerModel = GameScoringScoreAnswerModel(value: 0, type: .regular)
    
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
    
    /// A weak reference to the game, used to update survival state when applicable.
    private weak var game: (any AbstractGame)?
    
    /// Initializes the GameStats.
    /// - Parameter game: An optional instance conforming to `AbstractGame` for survival mode updates.
    init(game: (any AbstractGame)? = nil) {
        self.game = game
    }
    
    /// Updates the game statistics based on the correctness of the answer,
    /// the response time, the scoring mechanism, and whether a special card was used.
    /// - Parameters:
    ///   - correct: A Boolean indicating whether the answer was correct.
    ///   - responseTime: The time taken to provide the answer.
    ///   - scoring: An instance conforming to `AbstractGameScoring` used to compute score changes.
    ///   - isSpecialCard: A Boolean indicating if a special card was involved in the answer.
    final internal func updateGameStats(correct: Bool,
                                        responseTime: TimeInterval,
                                        scoring: GameScoring,
                                        isSpecialCard: Bool) {
        totalAverageResponseTime = ((totalAverageResponseTime * Double(totalAnswers)) + responseTime) / Double(totalAnswers + 1)
        averageResponseTime = responseTime
        
        if correct {
            streaks += 1
            correctAnswersStreak = max(correctAnswersStreak, streaks)
            
            let scoreModel = scoring.calculateScore(responseTime: responseTime, isSpecialCard: isSpecialCard, streaks: streaks)
            score = scoreModel
            totalScore += scoreModel.value
            correctAnswers += 1
        } else {
            streaks = 0
            
            let penaltyPoints = scoring.calculatePenalty()
            totalScore -= penaltyPoints
            if totalScore < 0 {
                totalScore = 0
            }
            score = GameScoringScoreAnswerModel(value: -penaltyPoints, type: .penalty)
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
    
    /// Updates the survival state if the game is in survival mode.
    private func updateSurvivalState() {
        if let game = game,
           game.state.currentMode == .survival,
           var survivalState = game.state.survivalState {
            survivalState.lives -= 1
            game.state.survivalState = survivalState
            
            if survivalState.lives <= 0 {
                Logger.debug("[GameStats]: Game over - no lives left")
                DispatchQueue.main.async {
                    game.state.end(reason: .noLives)
                }
            }
        }
    }
    
    func reset() {
        accuracy = 0
        streaks = 0
        correctAnswersStreak = 0
        score = GameScoringScoreAnswerModel(value: 0, type: .regular)
        averageResponseTime = 0
        totalAnswers = 0
        totalScore = 0
        totalAverageResponseTime = 0
        correctAnswers = 0
        Logger.debug("[GameStats]: Reset stats")
    }
}
