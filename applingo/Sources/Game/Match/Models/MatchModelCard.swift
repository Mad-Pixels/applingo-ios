import SwiftUI

struct MatchModelCard {
    let word: DatabaseModelWord
    
    let question: String
    let answer: String
    
    /// Initializes the MatchModelCard.
    /// - Parameters:
    ///   - word: The DatabaseModelWord used as the basis for the card.
    init(word: DatabaseModelWord) {
        self.question = word.frontText
        self.answer = word.backText
        
        self.word = word
    }
}
