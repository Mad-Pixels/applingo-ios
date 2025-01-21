import SwiftUI

class Quiz: ObservableObject, AbstractGame {
    let theme: GameTheme
    let type: GameType = .quiz
    let availableModes: [GameModeType] = [.practice, .survival, .time]
    let minimumWordsRequired: Int = 12
    let scoring: AbstractGameScoring
    
    lazy private(set) var stats: AbstractGameStats = {
        BaseGameStats()
    }()
    
    lazy private(set) var state: GameState = {
        GameState(stats: self.stats)
    }()
    
    init() {
        self.theme = ThemeManager.shared.currentThemeStyle.quizTheme
        self.scoring = BaseGameScoring(
            baseScore: 10,
            quickResponseThreshold: 0.6,
            quickResponseBonus: 5,
            specialCardBonus: 8
        )
    }
    
    lazy var gameView: some View = GameQuiz(game: self)
    
    var isReadyToPlay: Bool { true }
    
    func makeView() -> AnyView {
        AnyView(gameView)
    }
    
    func handleAnswer(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        if correct {
            let points = scoring.calculateScore(
                responseTime: responseTime,
                isSpecialCard: isSpecialCard
            )
            stats.score += points
        } else {
            stats.score -= scoring.calculatePenalty()
        }
    }
    
    func getModeModel(_ type: GameModeType) -> GameModeModel {
        switch type {
        case .practice:
            return .practice(locale: GameModeLocale())
        case .survival:
            return .survival(locale: GameModeLocale())
        case .time:
            return .time(locale: GameModeLocale())
        }
    }
    
    func start(mode: GameModeType) {
    }
    
    func end() {
    }
}
