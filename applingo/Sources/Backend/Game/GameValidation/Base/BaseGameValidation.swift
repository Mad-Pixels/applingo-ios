import SwiftUI

/// A base class that provides common functionality for validating answers in a game,
/// updating word statistics, and playing associated feedback.
/// Subclasses must override `validateImpl(answer:)` and `getCurrentWord()` to provide
/// game-specific validation logic and access to the current word.
class BaseGameValidation: AbstractGameValidation {
    // MARK: - Properties
    private var feedbacks: [GameValidationResult: AbstractGameFeedback]
    
    // MARK: - State Objects
    @StateObject private var wordAction = WordAction()
    
    // MARK: - Initializer
    /// Initializes a new instance of `BaseGameValidation` with the specified feedbacks.
    ///
    /// - Parameter feedbacks: A dictionary mapping validation results (e.g., `.correct`, `.incorrect`)
    ///   to the corresponding feedback implementations.
    init(feedbacks: [GameValidationResult: AbstractGameFeedback]) {
        self.feedbacks = feedbacks
    }

    // MARK: - Internal
    /// Validates the provided answer and returns the corresponding validation result.
    ///
    /// This method performs the following steps:
    /// 1. Calls `validateAnswer(answer:)` to compute the validation result.
    /// 2. If a current word is available, updates its statistics based on the result.
    /// 3. Returns the computed `GameValidationResult`.
    ///
    /// - Parameter answer: The answer provided by the user.
    /// - Returns: A `GameValidationResult` indicating whether the answer is correct, incorrect, or partial.
    final internal func validate(answer: Any) -> GameValidationResult {
        let result = validateAnswer(answer: answer)
        
        if let currentWord = getCurrentWord() {
            updateWordStats(word: currentWord, result: result)
        }
        return result
    }
    
    /// Plays the feedback associated with the given validation result.
    ///
    /// - Parameter result: The result of the validation.
    final internal func playFeedback(_ result: GameValidationResult) {
        feedbacks[result]?.play()
    }
    
    /// Calculates the new weight for a word based on its success and fail counts.
    ///
    /// The weight is calculated using the formula:
    ///   weight = 500 + (500 * (success - fail) / (success + fail))
    /// The resulting weight is clamped between 0 and 1000.
    ///
    /// - Parameters:
    ///   - success: The number of times the word was answered correctly.
    ///   - fail: The number of times the word was answered incorrectly.
    /// - Returns: The calculated weight as an `Int`.
    static func calculateWeight(success: Int, fail: Int) -> Int {
        let total = Double(success + fail)
        if total > 0 {
            let ratio = Double(success - fail) / total
            let calculatedWeight = Int(500.0 + (500.0 * ratio))
            return min(1000, max(0, calculatedWeight))
        } else {
            return 500
        }
    }
    
    /// Updates the statistics of the provided word based on the validation result.
    ///
    /// The update includes:
    /// - Incrementing the success or fail counters.
    /// - Recalculating the word's weight using `calculateWeight(success:fail:)`.
    ///
    /// - Parameters:
    ///   - word: The `DatabaseModelWord` to update.
    ///   - result: The result of the validation.
    final private func updateWordStats(word: DatabaseModelWord, result: GameValidationResult) {
        var updatedWord = word
        
        switch result {
        case .correct:
            updatedWord.success += 1
        case .incorrect:
            updatedWord.fail += 1
        case .partial:
            return
        }

        updatedWord.weight = BaseGameValidation.calculateWeight(success: updatedWord.success, fail: updatedWord.fail)

        wordAction.update(updatedWord) { result in
            switch result {
            case .success:
                Logger.debug(
                    "[WordStats]: Successfully updated word stats",
                    metadata: [
                        "newWeight": String(updatedWord.weight),
                        "success": String(updatedWord.success),
                        "fail": String(updatedWord.fail)
                    ]
                )
            case .failure(_):
                break
            }
        }
    }
    
    // MARK: - Methods to Override
    /// Must be overridden by subclasses to implement the specific answer validation logic.
    ///
    /// - Parameter answer: The answer provided by the user.
    /// - Returns: `GameValidationResult` based on game-specific criteria.
    func validateAnswer(answer: Any) -> GameValidationResult {
        fatalError("Must be overridden by concrete game")
    }
    
    /// Must be overridden by subclasses to provide the current word for validation.
    ///
    /// - Returns: The current `DatabaseModelWord`, if available.
    func getCurrentWord() -> DatabaseModelWord? {
        fatalError("Must be overridden by concrete game")
    }
}
