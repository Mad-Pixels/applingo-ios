import SwiftUI

class BaseGameScoring: AbstractGameScoring {
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
        0
    }
    
    func calculatePenalty() -> Int {
        0
    }
}
