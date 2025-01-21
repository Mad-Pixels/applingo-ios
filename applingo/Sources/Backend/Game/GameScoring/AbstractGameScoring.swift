import SwiftUI

protocol AbstractGameScoring {
    var baseScore: Int { get }
    var quickResponseThreshold: TimeInterval { get }
    var quickResponseBonus: Int { get }
    var specialCardBonus: Int { get }
    
    func calculateScore(responseTime: TimeInterval, isSpecialCard: Bool) -> Int
    func calculatePenalty() -> Int
}
