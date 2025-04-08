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
    
    override func playFeedback(_ result: GameValidationResult, answer: String? = nil, selected: String? = nil) {
        guard let answer = answer else { return }

        let correctAnswer: String? = {
            if answer == "false" {
                return "true"
            } else {
                return nil
            }
        }()

        let context = FeedbackContext(
            selectedOption: answer,
            correctOption: correctAnswer,
            customOption: selected
        )
        play(context: context, result: result)
    }
}
