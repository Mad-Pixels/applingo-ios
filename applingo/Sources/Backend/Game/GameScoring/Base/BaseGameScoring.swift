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
    
    func calculateScore(responseTime: TimeInterval, isSpecialCard: Bool) -> Int {
        var totalScore = baseScore
        
        if responseTime <= quickResponseThreshold {
            totalScore += quickResponseBonus
        }
        
        if isSpecialCard {
            totalScore += specialCardBonus
        }

        Logger.debug("[Scoring]: Calculated score: \(totalScore)")
        return totalScore
    }
    
    func calculatePenalty() -> Int {
        Logger.debug("[Scoring]: Calculated penalty: \(baseScore / 2)")
        return baseScore / 2
    }
}
