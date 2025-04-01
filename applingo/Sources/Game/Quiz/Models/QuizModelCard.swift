import SwiftUI

struct QuizModelCard {
    let word: DatabaseModelWord
    
    let question: String
    let answer: String
    let options: [String]
    
    /// Initializes the QuizModelCard.
    /// - Parameters:
    ///   - correctWord: The DatabaseModelWord used as the basis for the card.
    ///   - allWords: An array of DatabaseModelWord objects used to extract answer options.
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord]) {
        self.options = allWords.map { $0.backText }
        self.question = word.frontText
        self.answer = word.backText
        
        self.word = word
    }
}
