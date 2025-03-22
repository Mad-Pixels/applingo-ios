import SwiftUI
import Combine

/// Класс Math, реализующий игровую логику викторины.
final class Match: ObservableObject, AbstractGame {
    @Published private(set) var stats = GameStats()
    @Published private(set) var isLoadingCache: Bool = false
    
    // MARK: - Свойства
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    internal let type: GameType = .match
    internal let validation: AbstractGameValidation
    internal let scoring: GameScoring
    internal let cache: MatchCache
    internal let theme: GameTheme
    
    /// Игра готова к запуску, если кэш не пустой.
    internal var isReadyToPlay: Bool {
        !cache.cache.isEmpty
    }
    
    private var gameTimer: GameStateUtilsTimer?
    /// Текущее состояние игры.
    private(set) var state: GameState
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Инициализация
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.matchTheme,
        scoring: GameScoring = GameScoring(
            baseScore: MATCH_SCORE_SUCCESS,
            quickResponseThreshold: MATCH_SCORE_THRESHOLD,
            quickResponseBonus: MATCH_SCORE_QUICK_BONUS,
            specialCardBonus: MATCH_SCORE_SPECIAL_BONUS
        ),
        validation: any AbstractGameValidation = MatchValidation(
            feedbacks: [.incorrect: [IncorrectAnswerHapticFeedback()]]
        ),
        cacheGetter: MatchCache = MatchCache(
            cacheSize: MATCH_CACHE_SIZE,
            threshold: MATCH_CACHE_THRESHOLD
        )
    ) {
        self.theme = theme
        self.scoring = scoring
        self.validation = validation
        self.cache = cacheGetter
        
        self.state = GameState()
        self.stats = GameStats(game: self)
        
        cache.$isLoadingCache
            .sink { [weak self] isLoading in
                self?.isLoadingCache = isLoading
            }
            .store(in: &cancellables)
                    
        cache.$cache
            .sink { words in
                Logger.debug("[Match]: Cache updated", metadata: [
                    "count": String(words.count)
                ])
            }
            .store(in: &cancellables)
    }
    
    // MARK: - View Generation
    /// Создает представление игры с внедренным кэшем.
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameMatch(game: self)
                .environmentObject(cache)
        )
    }
    
    // MARK: - Внутренняя логика
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
        Logger.debug("[Match]: Requesting items", metadata: [
            "count": String(count),
            "isLoading": String(isLoadingCache),
            "cacheSize": String(cache.cache.count)
        ])
        let items = cache.getItems(count)
        
        if items == nil && !isLoadingCache {
            cache.initialize()
        }
        return items
    }

    internal func removeItem(_ item: any Hashable) {
        if let word = item as? DatabaseModelWord {
            cache.removeItem(word)
            Logger.debug("[Match]: Removed item from cache", metadata: [
                "word": word.frontText,
                "remaining": String(cache.cache.count)
            ])
        }
    }
    
    // MARK: - Методы запуска и остановки игры
    func start() {
        Logger.debug("[Match]: Starting game")
            cache.initialize()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }
                Logger.debug("[Match]: Checking cache status", metadata: [
                    "isReady": String(self.isReadyToPlay),
                    "isLoading": String(self.isLoadingCache),
                    "cacheSize": String(self.cache.cache.count)
                ])
                
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
}
