import SwiftUI
import Combine

final class Swipe: ObservableObject, AbstractGame {
    @Published private(set) var isLoadingCache: Bool = false
    @Published private(set) var stats = GameStats()
    
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    internal let validation: AbstractGameValidation
    internal let type: GameType = .swipe
    internal let scoring: GameScoring
    internal let cache: SwipeCache
    internal let theme: GameTheme
    
    private var cancellables = Set<AnyCancellable>()
    private var gameTimer: GameStateUtilsTimer?
    private var cacheInitialized = false
    private(set) var state: GameState
    
    /// Initializes the Quiz.
    /// - Parameters:
    ///   - theme: Visual theme for the quiz game. Defaults to the current application theme's swipe-specific settings.
    ///   - scoring: Scoring rules that determine point calculation. Defaults to standard swipe scoring with
    ///     predefined base scores, quick response bonuses, and special card bonuses.
    ///   - validation: Answer validation logic with feedback mechanisms. Defaults to a SwipeValidation instance
    ///     configured with visual and haptic feedback for both correct and incorrect answers.
    ///   - cacheGetter: Word cache provider that supplies swipe questions. Defaults to a standard
    ///     SwipeCache with predefined size and threshold parameters.
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.swipeTheme,
        scoring: GameScoring = GameScoring(
            baseScore: SWIPE_SCORE_SUCCESS,
            quickResponseThreshold: SWIPE_SCORE_THRESHOLD,
            quickResponseBonus: SWIPE_SCORE_QUICK_BONUS,
            specialCardBonus: SWIPE_SCORE_SPECIAL_BONUS
        ),
        validation: any AbstractGameValidation = SwipeValidation(
            feedbacks: [
                .incorrect: [
                    IncorrectAnswerHapticFeedback(),
                    IncorrectAnswerBackgroundVisualFeedback(
                        theme: ThemeManager.shared.currentThemeStyle.swipeTheme
                    )
                ]
            ]
        ),
        cacheGetter: SwipeCache = SwipeCache(
            cacheSize: SWIPE_CACHE_SIZE,
            threshold: SWIPE_CACHE_THRESHOLD
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
                Logger.debug("[Swipe]: Cache updated", metadata: [
                    "count": String(words.count)
                ])
            }
            .store(in: &cancellables)
    }
    
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameSwipe(game: self)
                .environmentObject(cache)
        )
    }
    
    func start() {
        if !cacheInitialized {
            self.cache.initialize()
            cacheInitialized = true
        }
        
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
        !cache.cache.isEmpty && cache.cache.count >= SWIPE_MIN_WORDS_IN_CACHE
    }
    
    internal func validateAnswer(_ answer: Bool) -> GameValidationResult {
        let result = validation.validate(answer: answer)
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
        return cache.getItems(count)
    }

    internal func removeItem(_ item: any Hashable) {
        if let word = item as? DatabaseModelWord {
            cache.removeItem(word)
        }
    }
}
