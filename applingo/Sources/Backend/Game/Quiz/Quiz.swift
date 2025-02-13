import SwiftUI

final class Quiz: ObservableObject, AbstractGame {
    let validation: any AbstractGameValidation
    let theme: GameTheme
    let type: GameType = .quiz
    let availableModes: [GameModeType] = [.practice, .survival, .time]
    let scoring: AbstractGameScoring
    
    private(set) var cacheGetter: WordCache? = WordCache(
        cacheSize: 10,
        threshold: 6
    )
    
    @Published private(set) var statsObject = BaseGameStats()
    var stats: any AbstractGameStats { statsObject }
    
    private(set) lazy var state: GameState = {
        GameState(stats: stats)
    }()
    
    init() {
        self.theme = ThemeManager.shared.currentThemeStyle.quizTheme
        self.scoring = BaseGameScoring(
            baseScore: 8,
            quickResponseThreshold: 0.6,
            quickResponseBonus: 5,
            specialCardBonus: 15
        )
        self.validation = QuizValidation(
            feedbacks: [
                .correct: CorrectAnswerHapticFeedback(),
            ]
        )
    }
    
    lazy var gameView: AnyView = {
        if let cache = cacheGetter {
            return AnyView(GameQuiz(game: self).environmentObject(cache))
        } else {
            return AnyView(ErrorView(message: "Failed to initialize game cache"))
        }
    }()
    
    var isReadyToPlay: Bool {
        cacheGetter != nil
    }
    
    func makeView() -> AnyView {
        AnyView(gameView)
    }
    
    func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result)
        return result
    }
    
    func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        if correct {
            let points = scoring.calculateScore(
                responseTime: responseTime,
                isSpecialCard: isSpecialCard
            )
            Logger.debug("[Quiz]: Adding points: \(points), current score: \(statsObject.score)")
            statsObject.score += points
            Logger.debug("[Quiz]: New score: \(statsObject.score)")
        } else {
            let penalty = scoring.calculatePenalty()
            Logger.debug("[Quiz]: Subtracting penalty: \(penalty), current score: \(statsObject.score)")
            statsObject.score -= penalty
            Logger.debug("[Quiz]: New score: \(statsObject.score)")
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
        state.currentMode = mode
        cacheGetter?.initializeCache()
        
        switch mode {
        case .survival:
            state.survivalState = GameState.SurvivalState(lives: 3)
        case .time:
            state.timeState = GameState.TimeState(timeLeft: 120)
        case .practice:
            break
        }
    }
    
    func end() {
        cacheGetter?.clearCache()
    }
}

struct ErrorView: View {
    let message: String
    
    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
        }
    }
}
