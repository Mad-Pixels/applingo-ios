import SwiftUI

class BaseGameValidation: AbstractGameValidation {
    private var feedbacks: [GameValidationResult: [AbstractGameFeedback]]
    private var wordAction: WordAction
    
    /// Initializes the BaseGameValidation.
    /// - Parameter feedbacks: A dictionary mapping validation results (e.g., `.correct`, `.incorrect`).
    init(feedbacks: [GameValidationResult: [AbstractGameFeedback]]) {
        self.wordAction = WordAction()
        self.feedbacks = feedbacks
    }

    /// Returns the correct answer for the current question, if available.
    /// - Returns: The correct answer as a String, or nil if not available.
    func getCorrectAnswer() -> String? {
        return nil
    }
    
    /// Must be overridden by subclasses to implement the specific answer validation logic.
    /// - Parameter answer: The answer provided by the user.
    /// - Returns: `GameValidationResult` based on game-specific criteria.
    func validateAnswer(answer: Any) -> GameValidationResult {
        fatalError("Must be overridden by concrete game")
    }
    
    /// Must be overridden by subclasses to provide the current word for validation.
    /// - Returns: The current `DatabaseModelWord`, if available.
    func getCurrentWord() -> DatabaseModelWord? {
        fatalError("Must be overridden by concrete game")
    }
    
    /// Validates the provided answer and returns the corresponding validation result.
    /// - Parameter answer: The answer provided by the user.
    /// - Returns: A `GameValidationResult` indicating whether the answer is correct, incorrect, or partial.
    final internal func validate(answer: Any) -> GameValidationResult {
        let result = validateAnswer(answer: answer)
        
        if let currentWord = getCurrentWord() {
            updateWordStats(word: currentWord, result: result)
        }
        return result
    }
    
    /// Plays all feedback mechanisms associated with the given validation result.
    /// - Parameters:
    ///   - result: The validation result determining which feedbacks to play.
    ///   - answer: The answer selected by the user. If nil, no feedback will be played.
    ///   - selected: The selected answer (different card).
    final internal func playFeedback(_ result: GameValidationResult, answer: String? = nil, selected: String? = nil) {
        guard let answer = answer else { return }
        
        let correctAnswer: String? = getCorrectAnswer()
        let context = FeedbackContext(
            selectedOption: answer,
            correctOption: result == .incorrect ? correctAnswer : nil,
            customOption: selected
        )
        
        feedbacks[result]?.forEach { feedback in
            feedback.play(context: context)
        }
    }
    
    /// Updates the statistics of the provided word based on the validation result.
    /// - Parameters:
    ///   - word: The `DatabaseModelWord` to update.
    ///   - result: The result of the validation.
    private final func updateWordStats(word: DatabaseModelWord, result: GameValidationResult) {
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
    
    /// Calculates the new weight for a word based on its success and fail counts.
    /// - Parameters:
    ///   - success: The number of times the word was answered correctly.
    ///   - fail: The number of times the word was answered incorrectly.
    /// - Returns: The calculated weight as an `Int`.
    private static func calculateWeight(success: Int, fail: Int) -> Int {
        let total = Double(success + fail)
        if total > 0 {
            let ratio = Double(success - fail) / total
            let calculatedWeight = Int(500.0 + (500.0 * ratio))
            return min(1000, max(0, calculatedWeight))
        } else {
            return 500
        }
    }
}
