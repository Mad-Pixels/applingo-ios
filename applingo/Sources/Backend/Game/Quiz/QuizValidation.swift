import SwiftUI

class QuizValidation: BaseGameValidation {
    override func validate(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String else {
            return .incorrect
        }
        // Логика валидации строкового ответа
        return .correct
    }
}
