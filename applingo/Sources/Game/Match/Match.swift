import SwiftUI
import Combine

final class Match: ObservableObject, AbstractGame {
    @Published private(set) var isLoadingCache: Bool = false
    @Published private(set) var stats = GameStats()
    
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    internal let validation: AbstractGameValidation
    internal let type: GameType = .match
    internal let scoring: GameScoring
    internal let cache: MatchCache
    internal let theme: GameTheme
    
    private var cancellables = Set<AnyCancellable>()
    private var gameTimer: GameStateUtilsTimer?
    private var cacheInitialized = false
    private(set) var state: GameState
    
    /// Initializes the Match.
    /// - Parameters:
    ///   - theme: Visual theme for the quiz game. Defaults to the current application theme's match-specific settings.
    ///   - scoring: Scoring rules that determine point calculation. Defaults to standard match scoring with
    ///     predefined base scores, quick response bonuses, and special card bonuses.
    ///   - validation: Answer validation logic with feedback mechanisms. Defaults to a MatchValidation instance
    ///     configured with visual and haptic feedback for both correct and incorrect answers.
    ///   - cacheGetter: Word cache provider that supplies match questions. Defaults to a standard
    ///     MatchCache with predefined size and threshold parameters.
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.matchTheme,
        scoring: GameScoring = GameScoring(
            baseScore: MATCH_SCORE_SUCCESS,
            quickResponseThreshold: MATCH_SCORE_THRESHOLD,
            quickResponseBonus: MATCH_SCORE_QUICK_BONUS,
            specialCardBonus: MATCH_SCORE_SPECIAL_BONUS
        ),
        validation: any AbstractGameValidation = MatchValidation(
            feedbacks: [
                .incorrect: [
                    IncorrectAnswerHapticFeedback(),
                    IncorrectAnswerBackgroundVisualFeedback(
                        theme: ThemeManager.shared.currentThemeStyle.matchTheme
                    )
                ]
            ]
        ),
        cacheGetter: MatchCache = MatchCache(
            cacheSize: MATCH_CACHE_SIZE,
            threshold: MATCH_CACHE_THRESHOLD
        )
    ) {
        self.validation = validation
        self.cache = cacheGetter
        self.scoring = scoring
        self.theme = theme
        
        self.state = GameState()
        self.stats = GameStats(game: self)
    }
    
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameMatch(game: self)
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
        !cache.cache.isEmpty && cache.cache.count >= MATCH_MIN_WORDS_IN_CACHE
    }
    
    internal func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result, answer: answer, selected: nil)
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
