import SwiftUI

final class BaseGameScoring: AbstractGameScoring {
    let baseScore: Int
    let quickResponseThreshold: TimeInterval
    let quickResponseBonus: Int
    let specialCardBonus: Int
    
    init(
        baseScore: Int,
        quickResponseThreshold: TimeInterval,
        quickResponseBonus: Int,
        specialCardBonus: Int
    ) {
        self.baseScore = baseScore
        self.quickResponseThreshold = quickResponseThreshold
        self.quickResponseBonus = quickResponseBonus
        self.specialCardBonus = specialCardBonus
    }
    
    func calculateScore(responseTime: TimeInterval, isSpecialCard: Bool, streaks: Int) -> Int {
        var totalScore = baseScore
        
        if responseTime <= quickResponseThreshold {
            totalScore += quickResponseBonus
        }
        if isSpecialCard {
            totalScore += specialCardBonus
        }
        totalScore += streaks

        Logger.debug("[Scoring]: Calculated score: \(totalScore)")
        return totalScore
    }
    
    func calculatePenalty() -> Int {
        Logger.debug("[Scoring]: Calculated penalty: \(baseScore / 2)")
        return baseScore / 2
    }
    
    func getScoreChanges(responseTime: TimeInterval, isSpecialCard: Bool, isCorrect: Bool, streaks: Int) -> ScoreChange {
        if isCorrect {
            var bonusTypes: [ScoreChange.BonusType] = []
            var total = baseScore
            
            if responseTime <= quickResponseThreshold {
                total += quickResponseBonus
                bonusTypes.append(.quickResponse)
            }
            
            if isSpecialCard {
                total += specialCardBonus
                bonusTypes.append(.specialCard)
            }
            
            if streaks > 0 {
                total += streaks
                bonusTypes.append(.streak)
            }
            
            return ScoreChange(
                totalValue: total,
                bonusTypes: bonusTypes
            )
        } else {
            return ScoreChange(
                totalValue: -calculatePenalty(),
                bonusTypes: []
            )
        }
    }
}
