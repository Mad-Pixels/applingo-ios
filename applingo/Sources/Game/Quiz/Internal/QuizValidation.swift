import SwiftUI

internal final class QuizValidation: BaseGameValidation {
    private var currentCard: QuizModelCard?
    private var currentWord: DatabaseModelWord?
    
    func setCurrentCard(currentCard: QuizModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        return answer.lowercased() == card.answer.lowercased() ? .correct : .incorrect
    }
    
    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
    
    override func getCorrectAnswer() -> String? {
        return currentCard?.answer
    }
}
