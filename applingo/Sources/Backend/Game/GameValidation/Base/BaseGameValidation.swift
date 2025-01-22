import SwiftUI

class BaseGameValidation: AbstractGameValidation {
    private var feedbacks: [GameValidationResult: AbstractGameFeedback]
    
    init(feedbacks: [GameValidationResult: AbstractGameFeedback]) {
        self.feedbacks = feedbacks
    }
    
    func validate(answer: Any) -> GameValidationResult {
        fatalError("Must be overridden by concrete game")
    }
    
    func playFeedback(_ result: GameValidationResult) {
        feedbacks[result]?.play()
    }
}
