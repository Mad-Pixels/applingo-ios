import SwiftUI

struct QuizModelCard {
    let word: DatabaseModelWord
    
    let question: String
    let answer: String
    let options: [String]
    let voice: Bool
    
    /// Initializes the QuizModelCard.
    /// - Parameters:
    ///   - word: The DatabaseModelWord used as the basis for the card.
    ///   - allWords: An array of DatabaseModelWord objects used to extract answer options.
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], voice: Bool = false) {
        self.options = allWords.map { $0.frontText }
        self.question = word.backText
        self.answer = word.frontText
        
        self.voice = voice
        
        self.word = word
    }
}
