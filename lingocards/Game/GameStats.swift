import SwiftUI

import SwiftUI

class GameStatsModel: ObservableObject {
    @Published var averageResponseTime: TimeInterval = 0
    @Published var timeRemaining: TimeInterval = 150
    
    @Published var correctAnswers: Int = 0
    @Published var wrongAnswers: Int = 0
    @Published var score: Int = 0
    
    @Published var bestStreak: Int = 0
    @Published var streak: Int = 0
    @Published var lives: Int = 3
    
    func updateStats(
        isCorrect: Bool,
        responseTime: TimeInterval,
        isSpecial: Bool = false,
        hintPenalty: Int = 0
    ) -> GameScoreCalculator.ScoreResult {
        if isCorrect {
            correctAnswers += 1
            streak += 1
            bestStreak = max(bestStreak, streak)
            
            let scoreResult = GameScoreCalculator.calculateScore(
                isCorrect: true,
                streak: streak,
                responseTime: responseTime,
                isSpecial: isSpecial
            )
            score += scoreResult.totalScore - hintPenalty
            return scoreResult
        } else {
            wrongAnswers += 1
            streak = 0
            lives -= 1
            score -= 10
            return GameScoreCalculator.ScoreResult(
                baseScore: -10,
                timeBonus: 0,
                streakBonus: 0,
                specialBonus: 0,
                totalScore: -10,
                reason: .normal
            )
        }
    }
}

