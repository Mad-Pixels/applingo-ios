import SwiftUI

struct MatchModelCard: Equatable {
    let word: DatabaseModelWord
    let question: String
    let answer: String
    
    init(word: DatabaseModelWord) {
        self.question = word.frontText
        self.answer = word.backText
        self.word = word
    }
    
    /// Compare only question and answer.
    static func == (lhs: MatchModelCard, rhs: MatchModelCard) -> Bool {
        return lhs.question == rhs.question && lhs.answer == rhs.answer
    }
}
