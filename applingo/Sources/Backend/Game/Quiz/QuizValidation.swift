import SwiftUI

class QuizValidation: BaseGameValidation {
    private var currentCard: QuizModelCard?
    
    func setCurrentCard(_ card: QuizModelCard) {
        self.currentCard = card
    }
    
    override func validate(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        
        return answer == card.correctAnswer ? .correct : .incorrect
    }
}
