import SwiftUI

struct GameStatsModel {
    var averageResponseTime: TimeInterval = 0
    var timeRemaining: TimeInterval = 150
    
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var score: Int = 0
    
    var bestStreak: Int = 0
    var streak: Int = 0
    var lives: Int = 3
    
    mutating func updateStats(isCorrect: Bool, responseTime: TimeInterval) {
        if isCorrect {
            correctAnswers += 1
            streak += 1
            bestStreak = max(bestStreak, streak)

            let timeBonus = max(5 * (1.0 - responseTime/3.0), 1)
            let streakMultiplier = min(Double(streak) * 0.1 + 1.0, 2.0)
            score += Int(Double(10 + Int(timeBonus)) * streakMultiplier)
        } else {
            wrongAnswers += 1
            streak = 0
            lives -= 1
        }
        let totalAnswers = correctAnswers + wrongAnswers
        averageResponseTime = (averageResponseTime * Double(totalAnswers - 1) + responseTime) / Double(totalAnswers)
    }
}
