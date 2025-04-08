import SwiftUI

final class GameScoring {
    let quickResponseThreshold: TimeInterval
    
    let baseScore: Int
    let quickResponseBonus: Int
    let specialCardBonus: Int
    
    /// Initializes the GameScoring.
    /// - Parameters:
    ///   - baseScore: The standard number of points awarded for a correct answer.
    ///   - quickResponseThreshold: The maximum time in seconds that qualifies for a quick response bonus.
    ///   - quickResponseBonus: Additional points awarded when the player answers within the quick response threshold.
    ///   - specialCardBonus: Additional points awarded when a special card is used for the answer.
    init(
        baseScore: Int,
        quickResponseThreshold: TimeInterval,
        quickResponseBonus: Int,
        specialCardBonus: Int
    ) {
        self.quickResponseThreshold = quickResponseThreshold
        self.quickResponseBonus = quickResponseBonus
        self.specialCardBonus = specialCardBonus
        self.baseScore = baseScore
    }
    
    /// Calculates the score for a correct answer and returns a model with the score value and its type.
    /// - Parameters:
    ///   - responseTime: The time taken by the player to respond.
    ///   - isSpecialCard: A Boolean indicating if a special card was used.
    ///   - streaks: The current streak count of correct answers.
    /// - Returns: A `GameScoringScoreAnswerModel` containing the calculated score and the corresponding score type.
    func calculateScore(responseTime: TimeInterval, isSpecialCard: Bool, streaks: Int) -> GameScoringScoreAnswerModel {
        var totalScore = baseScore
        var bonusCount = 0
        
        let quickBonus = responseTime <= quickResponseThreshold
        if quickBonus {
            totalScore += quickResponseBonus
            bonusCount += 1
        }
        
        let specialBonus = isSpecialCard
        if specialBonus {
            totalScore += specialCardBonus
            bonusCount += 1
        }
        
        let streakBonus = streaks > 5
        if streakBonus {
            bonusCount += 1
        }
        
        // Всегда добавляем количество streaks
        totalScore += streaks
        
        var scoreType: ScoreType = .regular
        if bonusCount > 1 {
            scoreType = .multiple
        } else if bonusCount == 1 {
            if specialBonus {
                scoreType = .specialCard
            } else if streakBonus {
                scoreType = .streakBonus
            } else if quickBonus {
                scoreType = .fastResponse
            }
        }
        
        Logger.debug("[Scoring]: Calculated score: \(totalScore) with type: \(scoreType)")
        return GameScoringScoreAnswerModel(value: totalScore, type: scoreType)
    }
    
    /// Calculates the penalty for an incorrect answer.
    /// - Returns: The penalty value as an integer.
    func calculatePenalty() -> Int {
        let penalty = baseScore / 2
        Logger.debug("[Scoring]: Calculated penalty: \(penalty)")
        return penalty
    }
}
