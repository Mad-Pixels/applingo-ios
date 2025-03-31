import SwiftUI
import Combine

final class Quiz: ObservableObject, AbstractGame {
    @Published private(set) var isLoadingCache: Bool = false
    @Published private(set) var stats = GameStats()
    
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    internal let validation: AbstractGameValidation
    internal let type: GameType = .quiz
    internal let scoring: GameScoring
    internal let cache: QuizCache
    internal let theme: GameTheme
    
    private var cancellables = Set<AnyCancellable>()
    private var gameTimer: GameStateUtilsTimer?
    private(set) var state: GameState
    
    /// Initializes the Quiz.
    /// - Parameters:
    ///   - theme: Visual theme for the quiz game. Defaults to the current application theme's quiz-specific settings.
    ///   - scoring: Scoring rules that determine point calculation. Defaults to standard quiz scoring with
    ///     predefined base scores, quick response bonuses, and special card bonuses.
    ///   - validation: Answer validation logic with feedback mechanisms. Defaults to a QuizValidation instance
    ///     configured with visual and haptic feedback for both correct and incorrect answers.
    ///   - cacheGetter: Word cache provider that supplies quiz questions. Defaults to a standard
    ///     QuizCache with predefined size and threshold parameters.
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.quizTheme,
        scoring: GameScoring = GameScoring(
            baseScore: QUIZ_SCORE_SUCCESS,
            quickResponseThreshold: QUIZ_SCORE_THRESHOLD,
            quickResponseBonus: QUIZ_SCORE_QUICK_BONUS,
            specialCardBonus: QUIZ_SCORE_SPECIAL_BONUS
        ),
        validation: any AbstractGameValidation = QuizValidation(
            feedbacks: [
                .incorrect: [
                    IncorrectAnswerHapticFeedback(),
                    CompleteBackgroundVisualFeedback(
                        theme: ThemeManager.shared.currentThemeStyle.quizTheme
                    )
                ],
            ]
        ),
        cacheGetter: QuizCache = QuizCache(
            cacheSize: QUIZ_CACHE_SIZE,
            threshold: QUIZ_CACHE_THRESHOLD
        )
    ) {
        self.validation = validation
        self.cache = cacheGetter
        self.scoring = scoring
        self.theme = theme
        
        self.state = GameState()
        self.stats = GameStats(game: self)
        
        cache.$isLoadingCache
            .sink { [weak self] isLoading in
                self?.isLoadingCache = isLoading
            }
            .store(in: &cancellables)
                    
        cache.$cache
            .sink { words in
                Logger.debug("[Quiz]: Cache updated", metadata: [
                    "count": String(words.count)
                ])
            }
            .store(in: &cancellables)
    }
    
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameQuiz(game: self)
                .environmentObject(cache)
        )
    }
    
    func start() {
        cache.initialize()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if !self.isReadyToPlay && !self.isLoadingCache {
                self.state.showNoWords = true
            } else {
                self.state.initialize(for: self.state.currentMode ?? .practice)
            }
        }
    }
    
    func end() {
        state.end(reason: .userQuit)
        cache.clear()
    }
    
    internal var isReadyToPlay: Bool {
        !cache.cache.isEmpty && cache.cache.count >= QUIZ_MIN_WORDS_IN_CACHE
    }
    
    internal func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result, answer: answer)
        return result
    }
    
    internal func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        stats.updateGameStats(
            correct: correct,
            responseTime: responseTime,
            scoring: scoring,
            isSpecialCard: isSpecialCard
        )
    }
    
    internal func getModeModel(_ type: GameModeType) -> GameModeModel {
        switch type {
        case .practice:
            return .practice(locale: GameModeLocale())
        case .survival:
            return .survival(locale: GameModeLocale())
        case .time:
            return .time(locale: GameModeLocale())
        }
    }
    
    internal func getItems(_ count: Int) -> [any Hashable]? {
        let items = cache.getItems(count)
        
        if items == nil && !isLoadingCache {
            cache.initialize()
        }
        return items
    }

    internal func removeItem(_ item: any Hashable) {
        if let word = item as? DatabaseModelWord {
            cache.removeItem(word)
        }
    }
}
