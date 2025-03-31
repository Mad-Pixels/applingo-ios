import SwiftUI

struct QuizModelCard {
    let word: DatabaseModelWord
    
    let question: String
    let answer: String
    let options: [String]
    let showingFront: Bool
    
    /// Initializes the QuizModelCard.
    /// - Parameters:
    ///   - correctWord: The DatabaseModelWord used as the basis for the card.
    ///   - allWords: An array of DatabaseModelWord objects used to extract answer options.
    ///   - showingFront: A Boolean value that determines if the question is based on the front text.
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], showingFront: Bool) {
        self.options = allWords.map { showingFront ? $0.backText : $0.frontText }
        self.question = showingFront ? word.frontText : word.backText
        self.answer = showingFront ? word.backText : word.frontText
        
        self.showingFront = showingFront
        self.word = word
    }
}
