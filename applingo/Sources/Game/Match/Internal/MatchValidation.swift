import SwiftUI

final class MatchValidation: BaseGameValidation {
    private var currentCard: MatchModelCard?
    private var currentWord: DatabaseModelWord?
    
    func setCurrentCard(currentCard: MatchModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        return answer == card.answer ? .correct : .incorrect
    }
    
    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
    
    override func getCorrectAnswer() -> String? {
        return currentCard?.answer
    }
}
