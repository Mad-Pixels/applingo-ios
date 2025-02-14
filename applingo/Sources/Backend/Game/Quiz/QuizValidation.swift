import SwiftUI

/// Provides validation logic for the Quiz game.
/// This class extends `BaseGameValidation` and implements answer validation by comparing the user's answer
/// with the correct answer from the current quiz card.
final class QuizValidation: BaseGameValidation {
    
    // MARK: - Properties
    
    /// The current quiz card used for validation.
    /// This card holds the correct answer against which the user's answer will be compared.
    private var currentCard: QuizModelCard?
    
    // MARK: - Methods
    
    /// Sets the current quiz card to be used for answer validation.
    /// - Parameter card: The `QuizModelCard` instance representing the current quiz card.
    func setCurrentCard(_ card: QuizModelCard) {
        self.currentCard = card
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
    override func validate(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        return answer == card.correctAnswer ? .correct : .incorrect
    }
}
