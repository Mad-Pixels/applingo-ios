import SwiftUI

/// Provides validation logic for the Quiz game.
/// This class extends `BaseGameValidation` and implements answer validation by comparing the user's answer
/// with the correct answer from the current quiz card.
final class QuizValidation: BaseGameValidation {
    // MARK: - Properties
    /// The current quiz card used for validation.
    /// This card holds the correct answer against which the user's answer will be compared.
    private var currentCard: QuizModelCard?
    private var currentWord: DatabaseModelWord?
    
    // MARK: - Methods
    /// Sets the current quiz card and its associated word for answer validation.
    /// - Parameters:
    ///   - currentCard: The `QuizModelCard` instance representing the current quiz card.
    ///   - currentWord: The `DatabaseModelWord` instance associated with the current quiz card.
    func setCurrentCard(currentCard: QuizModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    /// Validates the provided answer against the correct answer of the current quiz card.
    ///
    /// The method attempts to cast the provided answer to a `String` and compares it with the
    /// correct answer stored in the current quiz card. If the cast fails or no current card is set,
    /// the method returns `.incorrect`.
    ///
    /// - Parameter answer: The answer provided by the user.
    /// - Returns: A `GameValidationResult` indicating whether the answer is correct (`.correct`)
    ///   or not (`.incorrect`).
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        return answer == card.answer ? .correct : .incorrect
    }
    
    /// Returns the current word associated with the quiz card for validation purposes.
    /// - Returns: An optional `DatabaseModelWord` instance representing the current word,
    ///   or `nil` if no current word is set.
    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
    
    override func getCorrectAnswer() -> String? {
        return currentCard?.answer
    }
}
