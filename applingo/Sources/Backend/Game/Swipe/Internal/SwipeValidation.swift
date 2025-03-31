import SwiftUI

final class SwipeValidation: BaseGameValidation {
    private var currentCard: SwipeModelCard?
    private var currentWord: DatabaseModelWord?
    
    func setCurrentCard(currentCard: SwipeModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? Bool,
              let card = currentCard else {
            return .incorrect
        }
        return answer == card.isCorrectPair ? .correct : .incorrect
    }

    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
}
