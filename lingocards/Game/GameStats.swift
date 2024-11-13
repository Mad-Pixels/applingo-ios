import SwiftUI

final class GameStatsModel: ObservableObject, GameStatsProtocol {
    @Published private(set) var averageResponseTime: TimeInterval = 0
    @Published private(set) var timeRemaining: TimeInterval
    
    @Published private(set) var correctAnswers: Int = 0
    @Published private(set) var wrongAnswers: Int = 0
    @Published private(set) var score: Int = 0
    
    @Published private(set) var bestStreak: Int = 0
    @Published private(set) var streak: Int = 0
    @Published private(set) var lives: Int = 0
    
    private let initialTime: TimeInterval
    private let initialLives: Int
    
    init(timeLimit: TimeInterval = 150, lives: Int = 3) {
        self.initialTime = timeLimit
        self.initialLives = lives
        self.timeRemaining = timeLimit
        self.lives = lives
    }
    
    func reset() {
        averageResponseTime = 0
        timeRemaining = initialTime
        correctAnswers = 0
        wrongAnswers = 0
        score = 0
        bestStreak = 0
        streak = 0
        lives = initialLives
    }
    
    func resetLives(to value: Int) {
        lives = value
    }
    
    func update(with result: GameResultProtocol, scoreResult: GameScoreResultProtocol) {
        updateAnswers(isCorrect: result.isCorrect)
        updateStreak(isCorrect: result.isCorrect)
        updateScore(result: scoreResult)
        updateResponseTime(result.responseTime)
    }
    
    func decrementTime() {
        guard timeRemaining > 0 else { return }
        timeRemaining -= 1
    }
    
    var totalAnswers: Int {
        correctAnswers + wrongAnswers
    }
    
    var accuracy: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
    
    var isGameOver: Bool {
        switch (timeRemaining, lives) {
        case (0, _): return true
        case (_, 0): return true
        default: return false
        }
    }
    
    private func updateAnswers(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        } else {
            wrongAnswers += 1
            lives = max(0, lives - 1)
        }
    }
    
    private func updateStreak(isCorrect: Bool) {
        if isCorrect {
            streak += 1
            bestStreak = max(bestStreak, streak)
        } else {
            streak = 0
        }
    }
    
    private func updateScore(result: GameScoreResultProtocol) {
        score += result.total
    }
    
    private func updateResponseTime(_ newTime: TimeInterval) {
        guard totalAnswers > 0 else {
            averageResponseTime = newTime
            return
        }
        
        let totalTime = averageResponseTime * Double(totalAnswers - 1)
        averageResponseTime = (totalTime + newTime) / Double(totalAnswers)
    }
}

extension GameStatsModel {
    struct Summary {
        let score: Int
        let accuracy: Double
        let averageResponseTime: TimeInterval
        let bestStreak: Int
        let totalAnswers: Int
        let correctAnswers: Int
        
        init(from stats: GameStatsModel) {
            self.score = stats.score
            self.accuracy = stats.accuracy
            self.averageResponseTime = stats.averageResponseTime
            self.bestStreak = stats.bestStreak
            self.totalAnswers = stats.totalAnswers
            self.correctAnswers = stats.correctAnswers
        }
    }
    
    var summary: Summary {
        Summary(from: self)
    }
}

extension GameStatsModel {
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    func formatAccuracy(_ accuracy: Double) -> String {
        String(format: "%.1f%%", accuracy * 100)
    }
    
    func formatResponseTime(_ time: TimeInterval) -> String {
        String(format: "%.2fs", time)
    }
}

extension GameStatsModel: Comparable {
    static func < (lhs: GameStatsModel, rhs: GameStatsModel) -> Bool {
        if lhs.score != rhs.score {
            return lhs.score < rhs.score
        }
        if lhs.accuracy != rhs.accuracy {
            return lhs.accuracy < rhs.accuracy
        }
        return lhs.averageResponseTime > rhs.averageResponseTime
    }
    
    static func == (lhs: GameStatsModel, rhs: GameStatsModel) -> Bool {
        lhs.score == rhs.score &&
        lhs.accuracy == rhs.accuracy &&
        lhs.averageResponseTime == rhs.averageResponseTime
    }
}

extension GameStatsModel: CustomStringConvertible {
    var description: String {
        """
        Game Stats:
        Score: \(score)
        Accuracy: \(formatAccuracy(accuracy))
        Average Response Time: \(formatResponseTime(averageResponseTime))
        Best Streak: \(bestStreak)
        Total Answers: \(totalAnswers)
        Correct Answers: \(correctAnswers)
        """
    }
}
