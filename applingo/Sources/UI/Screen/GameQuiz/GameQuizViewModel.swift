import Foundation

/// A view model for the Quiz game that encapsulates the logic for generating quiz cards and handling user answers.
///
/// The `QuizViewModel` is responsible for:
/// - Generating new quiz cards by retrieving a set of words from the game's cache.
/// - Setting up the current quiz card and delegating answer validation to the game model.
/// - Handling user answers by measuring response time, validating the answer, and updating game statistics.
/// - Regenerating quiz cards after an answer is processed.
///
/// This class is an `ObservableObject` so that SwiftUI views can reactively update when the current card changes.
final class QuizViewModel: ObservableObject {
    /// The currently active quiz card.
    @Published private(set) var currentCard: QuizModelCard?
    /// The timestamp when the current card was generated, used to calculate response time.
    private var cardStartTime: Date?
    /// A reference to the underlying quiz game model.
    private let game: Quiz
    
    /// Initializes a new instance of `QuizViewModel` with the given quiz game.
    ///
    /// - Parameter game: The quiz game model that provides game logic, state, and cache access.
    init(game: Quiz) {
        self.game = game
    }
    
    /// Generates a new quiz card using a set of words retrieved from the game's cache.
    ///
    /// This method attempts to retrieve four words from the cache. If successful, it selects the first word
    /// as the correct answer, removes it from the cache, and creates a new `QuizModelCard` with a random
    /// configuration (e.g., showing front or back). It also configures the validation object with the current
    /// card and its corresponding word, and records the start time of the card.
    func generateCard() {
        guard let items = game.getItems(4) as? [DatabaseModelWord] else {
            Logger.debug("[QuizViewModel]: Failed to get items, waiting for cache")
            return
        }
        
        let correctWord = items[0]
        game.removeItem(correctWord)
        
        currentCard = QuizModelCard(
            word: correctWord,
            allWords: items,
            showingFront: Bool.random()
        )
        
        if let validation = game.validation as? QuizValidation,
           let card = currentCard {
            validation.setCurrentCard(currentCard: card, currentWord: correctWord)
        }
        
        cardStartTime = Date()
    }
    
    /// Handles the user's answer by validating it, updating game statistics, and generating a new card.
    ///
    /// This method calculates the response time from when the current card was generated, validates the provided
    /// answer via the game model, and then updates the game statistics based on whether the answer was correct.
    /// After processing the answer, it immediately triggers the generation of a new quiz card.
    ///
    /// - Parameter answer: The answer provided by the user.
    func handleAnswer(_ answer: String) {
        let responseTime = cardStartTime.map { Date().timeIntervalSince($0) } ?? 0
        let result = game.validateAnswer(answer)
        
        game.updateStats(
            correct: result == .correct,
            responseTime: responseTime,
            isSpecialCard: false
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.generateCard()
        }
    }
}
