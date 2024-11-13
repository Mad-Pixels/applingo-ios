import SwiftUI

struct BaseScore {
    static let correct: Int = 10
    static let wrong: Int = -7
}

struct ScoreComponents {
    private(set) var baseScore: Int
    private(set) var timeBonus: Int = 0
    private(set) var streakBonus: Int = 0
    private(set) var specialBonus: Int = 0
    private(set) var hintPenalty: Int = 0
    
    var currentTotal: Int {
        baseScore + timeBonus + streakBonus + specialBonus - hintPenalty
    }
    
    init(baseScore: Int) {
        self.baseScore = baseScore
    }
    
    mutating func addTimeBonus(_ bonus: Int) {
        timeBonus += bonus
    }
    
    mutating func addStreakBonus(_ bonus: Int) {
        streakBonus += bonus
    }
    
    mutating func addSpecialBonus(_ bonus: Int) {
        specialBonus += bonus
    }
    
    mutating func addHintPenalty(_ penalty: Int) {
        hintPenalty += penalty
    }
}

struct GameScoreResult: GameScoreResultProtocol {
    let baseScore: Int
    let timeBonus: Int
    let streakBonus: Int
    let specialBonus: Int
    let hintPenalty: Int
    let total: Int
    let reason: ScoreAnimationReason
    
    init(components: ScoreComponents, reason: ScoreAnimationReason) {
        self.baseScore = components.baseScore
        self.timeBonus = components.timeBonus
        self.streakBonus = components.streakBonus
        self.specialBonus = components.specialBonus
        self.hintPenalty = components.hintPenalty
        self.total = components.currentTotal
        self.reason = reason
    }
    
    var isPositive: Bool { total > 0 }
}

struct TimeBonus: GameScoreModifierProtocol {
    let responseTime: TimeInterval
    private let maxBonusTime: TimeInterval = 1.0
    private let maxBonus: Int = 5
    
    func modifyScore(_ score: Int) -> Int {
        let timeFactor = max(0, 1.0 - responseTime/maxBonusTime)
        let bonus = Int(Double(maxBonus) * timeFactor)
        return score + max(bonus, 1)
    }
}

struct StreakBonus: GameScoreModifierProtocol {
    let streak: Int
    private let maxMultiplier: Double = 2.0
    private let multiplierStep: Double = 0.1
    
    func modifyScore(_ score: Int) -> Int {
        let multiplier = min(Double(streak) * multiplierStep + 1.0, maxMultiplier)
        return Int(Double(score) * multiplier)
    }
}

final class GameScoreCalculator {
    struct Config {
        let maxBonusTime: TimeInterval = 1.0
        let maxTimeBonus: Int = 5
        let maxStreakMultiplier: Double = 2.0
        let streakMultiplierStep: Double = 0.1
        
        static let standard = Config()
    }
    private let config: Config
    
    init(config: Config = .standard) {
        self.config = config
    }
    
    func calculateScore(
        result: GameResultProtocol,
        streak: Int,
        special: (any GameSpecialScoringProtocol)?
    ) -> GameScoreResult {
        var components = ScoreComponents(
            baseScore: result.isCorrect ? BaseScore.correct : BaseScore.wrong
        )
        
        if result.isCorrect {
            let timeBonus = TimeBonus(responseTime: result.responseTime)
            let scoreWithTimeBonus = timeBonus.modifyScore(components.currentTotal)
            components.addTimeBonus(scoreWithTimeBonus - components.currentTotal)
            
            let streakBonus = StreakBonus(streak: streak)
            let scoreWithStreakBonus = streakBonus.modifyScore(components.currentTotal)
            components.addStreakBonus(scoreWithStreakBonus - components.currentTotal)
            
            if let special = special {
                let specialScore = special.modifyScoreForCorrectAnswer(components.currentTotal)
                components.addSpecialBonus(specialScore - components.currentTotal)
            }
        } else {
            if let special = special {
                let specialScore = special.modifyScoreForWrongAnswer(components.currentTotal)
                components.addSpecialBonus(specialScore - components.currentTotal)
            }
        }
        
        components.addHintPenalty(result.hintPenalty)
        
        return GameScoreResult(
            components: components,
            reason: determineReason(
                responseTime: result.responseTime,
                hasSpecial: special != nil
            )
        )
    }
    
    private func determineReason(
        responseTime: TimeInterval,
        hasSpecial: Bool
    ) -> ScoreAnimationReason {
        switch (responseTime, hasSpecial) {
        case (_, true):
            return .special
        case (...config.maxBonusTime, false):
            return .fast
        default:
            return .normal
        }
    }
}

struct ScoreFormatter {
    static func formatScore(_ score: Int, showPlus: Bool = true) -> String {
        if score > 0 && showPlus {
            return "+\(score)"
        }
        return "\(score)"
    }
    
    static func formatComponents(_ result: GameScoreResult) -> String {
        var components: [String] = []
        
        if result.baseScore != 0 {
            components.append("Base: \(formatScore(result.baseScore))")
        }
        if result.timeBonus != 0 {
            components.append("Time: \(formatScore(result.timeBonus))")
        }
        if result.streakBonus != 0 {
            components.append("Streak: \(formatScore(result.streakBonus))")
        }
        if result.specialBonus != 0 {
            components.append("Special: \(formatScore(result.specialBonus))")
        }
        if result.hintPenalty != 0 {
            components.append("Hint: \(formatScore(-result.hintPenalty))")
        }
        
        components.append("Total: \(formatScore(result.total))")
        return components.joined(separator: "\n")
    }
}
