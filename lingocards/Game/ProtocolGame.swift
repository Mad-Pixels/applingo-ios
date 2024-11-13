import SwiftUI

protocol GameViewProtocol: View {
    var isPresented: Binding<Bool> { get }
}

protocol GameResultProtocol {
    var word: WordItemModel { get }
    var isCorrect: Bool { get }
    var responseTime: TimeInterval { get }
    var isSpecial: Bool { get }
    var hintPenalty: Int { get }
}

enum GameMode {
    case practice
    case survival
    case timeAttack
}

protocol GameFeedbackProtocol {
    func trigger()
}

protocol GameFeedbackVisualProtocol: GameFeedbackProtocol {
    associatedtype ModifierType: ViewModifier
    func modifier() -> ModifierType
}

protocol GameFeedbackHapticProtocol: GameFeedbackProtocol {
    func playHaptic()
}

protocol GameScoreModifierProtocol {
    func modifyScore(_ score: Int) -> Int
}

protocol GameScoreResultProtocol {
    var baseScore: Int { get }
    var timeBonus: Int { get }
    var streakBonus: Int { get }
    var specialBonus: Int { get }
    var hintPenalty: Int { get }
    var total: Int { get }
    var reason: ScoreAnimationReason { get }
}

protocol GameSpecialConfigProtocol {
    var weightThreshold: Int { get }
    var chance: Double { get }
    var scoreMultiplier: Double { get }
}

protocol GameSpecialProtocol {
    var config: GameSpecialConfigProtocol { get }
    
    func isSpecial(_ item: WordItemModel) -> Bool
    func modifiers() -> [AnyViewModifier]
}

protocol GameSpecialScoringProtocol {
    func modifyScoreForCorrectAnswer(_ score: Int) -> Int
    func modifyScoreForWrongAnswer(_ score: Int) -> Int
}

enum ScoreAnimationReason {
    case normal
    case fast
    case special
    case hint
    
    var icon: String {
        switch self {
        case .normal: return ""
        case .fast: return "bolt.fill"
        case .special: return "star.fill"
        case .hint: return "lightbulb.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .normal: return .primary
        case .fast: return .blue
        case .special: return .yellow
        case .hint: return .orange
        }
    }
}

protocol GameFlowProtocol {
    var isGameActive: Bool { get }
    var gameMode: GameMode { get }
    var stats: GameStatsProtocol { get }
    
    func startGame(mode: GameMode)
    func endGame()
    func handleResult(_ result: GameResultProtocol)
}

protocol GameSpecialServiceProtocol {
    func isSpecial(_ item: WordItemModel) -> Bool
    func getActiveSpecial() -> (any GameSpecialScoringProtocol)?
    func getModifiers() -> [AnyViewModifier]
}

protocol GameScoreServiceProtocol {
    func calculateScore(
        result: GameResultProtocol,
        streak: Int,
        special: (any GameSpecialScoringProtocol)?
    ) -> GameScoreResultProtocol
}

protocol AnyViewModifierProtocol {
    func modifyAny(_ view: AnyView) -> AnyView
}

extension View {
    func anyView() -> AnyView {
        AnyView(self)
    }
}

struct AnyGameSpecial: GameSpecialProtocol, GameSpecialScoringProtocol {
    private let _isSpecial: (WordItemModel) -> Bool
    private let _modifiers: () -> [AnyViewModifier]
    private let _modifyScoreForCorrectAnswer: (Int) -> Int
    private let _modifyScoreForWrongAnswer: (Int) -> Int
    private let _config: GameSpecialConfigProtocol
    
    var config: GameSpecialConfigProtocol { _config }
    
    init<S: GameSpecialProtocol & GameSpecialScoringProtocol>(_ special: S) {
        self._isSpecial = special.isSpecial
        self._modifiers = special.modifiers
        self._modifyScoreForCorrectAnswer = special.modifyScoreForCorrectAnswer
        self._modifyScoreForWrongAnswer = special.modifyScoreForWrongAnswer
        self._config = special.config
    }
    
    func isSpecial(_ item: WordItemModel) -> Bool {
        _isSpecial(item)
    }
    
    func modifiers() -> [AnyViewModifier] {
        _modifiers()
    }
    
    func modifyScoreForCorrectAnswer(_ score: Int) -> Int {
        _modifyScoreForCorrectAnswer(score)
    }
    
    func modifyScoreForWrongAnswer(_ score: Int) -> Int {
        _modifyScoreForWrongAnswer(score)
    }
}

protocol GameStatsProtocol {
    var averageResponseTime: TimeInterval { get }
    var timeRemaining: TimeInterval { get }
    var correctAnswers: Int { get }
    var wrongAnswers: Int { get }
    var score: Int { get }
    var bestStreak: Int { get }
    var streak: Int { get }
    var lives: Int { get }
    var totalAnswers: Int { get }
    var accuracy: Double { get }
    var isGameOver: Bool { get }
    var lastScoreResult: GameScoreResult? { get }
    var isLastAnswerCorrect: Bool { get }
    
    func reset()
    func resetLives(to value: Int)
    func update(with result: GameResultProtocol, scoreResult: GameScoreResult)
    func decrementTime()
    
    func formatTime(_ time: TimeInterval) -> String
    func formatAccuracy(_ accuracy: Double) -> String
    func formatResponseTime(_ time: TimeInterval) -> String
}

extension GameStatsProtocol {
    var totalAnswers: Int {
        correctAnswers + wrongAnswers
    }
    
    var accuracy: Double {
        guard totalAnswers > 0 else { return 0 }
        return Double(correctAnswers) / Double(totalAnswers)
    }
    
    var isGameOver: Bool {
        timeRemaining <= 0 || lives <= 0
    }
    
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
