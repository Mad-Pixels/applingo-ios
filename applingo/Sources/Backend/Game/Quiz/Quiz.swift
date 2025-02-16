import SwiftUI
import Combine

/// A quiz game class that implements game logic, answer validation, score calculation, and cache management.
///
/// The `Quiz` class conforms to `AbstractGame` and is responsible for:
/// - Handling game modes (practice, survival, time)
/// - Validating user answers using a validation strategy
/// - Calculating scores via a scoring strategy
/// - Managing a cache of quiz data
/// - Maintaining game state and statistics
final class Quiz: ObservableObject, AbstractGame {
    @Published private(set) var stats = GameStats()
    @Published private(set) var isLoadingCache: Bool = false
    
    // MARK: - Properties
    /// The available game modes for the quiz.
    internal let availableModes: [GameModeType] = [.practice, .survival, .time]
    /// The type of the game (quiz).
    internal let type: GameType = .quiz
    
    /// The game validation strategy.
    internal let validation: AbstractGameValidation
    /// The scoring strategy used to calculate score changes.
    internal let scoring: GameScoring
    /// The cache manager for quiz data.
    internal let cache: QuizCache
    /// The visual theme for the quiz.
    internal let theme: GameTheme
    /// Indicates whether the game is ready to be played.
    internal var isReadyToPlay: Bool {
        true
    }
    
    /// A timer used in certain game modes (not directly used here; managed by game state).
    private var gameTimer: GameStateUtilsTimer?
    /// The current state of the game, including mode-specific state such as survival lives or remaining time.
    private(set) var state: GameState
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    /// Initializes a new instance of the `Quiz` game with dependency injection.
    ///
    /// - Parameters:
    ///   - theme: The game theme. Defaults to the current quiz theme from `ThemeManager`.
    ///   - scoring: The scoring strategy. Defaults to a `BaseGameScoring` instance configured with predefined constants.
    ///   - validation: The validation strategy. Defaults to a `QuizValidation` instance with an incorrect answer feedback.
    ///   - cacheGetter: The cache manager. Defaults to a `QuizCache` instance configured with predefined constants.
    init(
        theme: GameTheme = ThemeManager.shared.currentThemeStyle.quizTheme,
        scoring: GameScoring = GameScoring(
            baseScore: QUIZ_SCORE_SUCCESS,
            quickResponseThreshold: QUIZ_SCORE_THRESHOLD,
            quickResponseBonus: QUIZ_SCORE_QUICK_BONUS,
            specialCardBonus: QUIZ_SCORE_SPECIAL_BONUS
        ),
        validation: any AbstractGameValidation = QuizValidation(
            feedbacks: [.incorrect: IncorrectAnswerHapticFeedback()]
        ),
        cacheGetter: QuizCache = QuizCache(
            cacheSize: QUIZ_CACHE_SIZE,
            threshold: QUIZ_CACHE_THRESHOLD
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
                Logger.debug("[Quiz]: Cache updated", metadata: [
                    "count": String(words.count)
                ])
            }
            .store(in: &cancellables)
    }
    
    // MARK: - View Generation
    /// Creates and returns the game view with the cache manager injected as an EnvironmentObject.
    ///
    /// - Returns: An `AnyView` representing the quiz interface.
    @ViewBuilder
    func makeView() -> AnyView {
        AnyView(
            GameQuiz(game: self)
                .environmentObject(cache)
        )
    }
    
    // MARK: - Internal Methods
    /// Validates the user's answer and returns the corresponding validation result.
    ///
    /// This method uses the injected validation strategy to determine if the answer is correct,
    /// then plays the associated feedback.
    ///
    /// - Parameter answer: The user's answer as a `String`.
    /// - Returns: A `GameValidationResult` indicating the outcome of the validation.
    internal func validateAnswer(_ answer: String) -> GameValidationResult {
        let result = validation.validate(answer: answer)
        validation.playFeedback(result)
        return result
    }
    
    /// Updates the game statistics based on the correctness of the answer, the response time,
    /// and whether a special card was used.
    ///
    /// - Parameters:
    ///   - correct: A Boolean indicating whether the answer was correct.
    ///   - responseTime: The time taken to provide the answer.
    ///   - isSpecialCard: A Boolean indicating if a special card was involved in the answer.
    internal func updateStats(correct: Bool, responseTime: TimeInterval, isSpecialCard: Bool) {
        stats.updateGameStats(
            correct: correct,
            responseTime: responseTime,
            scoring: scoring,
            isSpecialCard: isSpecialCard
        )
    }
    
    /// Returns a game mode model for the specified mode.
    ///
    /// This method creates a `GameModeModel` with localized information based on the selected mode.
    ///
    /// - Parameter type: The game mode type.
    /// - Returns: A `GameModeModel` corresponding to the given mode.
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
    
    /// Retrieves a specified number of items from the cache.
    ///
    /// This function delegates the request to the underlying cache object,
    /// returning an optional array of items that conform to the `Hashable` protocol.
    /// If the cache does not contain enough items, it may return nil.
    ///
    /// - Parameter count: The number of items to retrieve from the cache.
    /// - Returns: An optional array of items conforming to `Hashable`.
    internal func getItems(_ count: Int) -> [any Hashable]? {
        Logger.debug("[Quiz]: Requesting items", metadata: [
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

    /// Removes the specified item from the cache, if it is a `DatabaseModelWord`.
    ///
    /// This function checks if the provided item can be cast to a `DatabaseModelWord`.
    /// If so, it delegates the removal to the underlying cache object.
    ///
    /// - Parameter item: The item to remove, which must conform to `Hashable`.
    internal func removeItem(_ item: any Hashable) {
        if let word = item as? DatabaseModelWord {
            cache.removeItem(word)
            
            Logger.debug("[Quiz]: Removed item from cache", metadata: [
                "word": word.frontText,
                "remaining": String(cache.cache.count)
            ])
        }
    }
    
    // MARK: - Invoke Methods
    /// Starts the game with the given mode.
    ///
    /// This method initializes the game state for the selected mode and initializes the cache.
    ///
    /// - Parameter mode: The selected game mode.
    func start() {
        state.initialize(for: state.currentMode ?? .practice)
        cache.initialize()
    }
    
    /// Ends the game and clears the cache.
    ///
    /// This method signals the game state to end (with a user-quit reason) and clears any cached data.
    func end() {
        state.end(reason: .userQuit)
        cache.clear()
    }
}
