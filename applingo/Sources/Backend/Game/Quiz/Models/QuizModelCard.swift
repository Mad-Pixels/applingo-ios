import SwiftUI

/// A model representing a quiz card that holds the question, correct answer, and answer options.
struct QuizModelCard {
    let word: DatabaseModelWord
    /// The text of the question (either the front text or the back text).
    let question: String
    /// An array of answer options.
    let options: [String]
    /// A flag indicating whether the front text is shown as the question.
    let showingFront: Bool
    
    /// Initializes a new instance of QuizModelCard.
    /// - Parameters:
    ///   - correctWord: The DatabaseModelWord used as the basis for the card.
    ///   - allWords: An array of DatabaseModelWord objects used to extract answer options.
    ///   - showingFront: A Boolean value that determines if the question is based on the front text.
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], showingFront: Bool) {
        self.options = allWords.map { showingFront ? $0.backText : $0.frontText }
        self.question = showingFront ? word.frontText : word.backText
        self.showingFront = showingFront
        self.word = word
    }
}
