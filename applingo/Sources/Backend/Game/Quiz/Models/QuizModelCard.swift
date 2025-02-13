import SwiftUI

/// A model representing a quiz card that holds the question, correct answer, and answer options.
struct QuizModelCard {
    /// The text of the question (either the front text or the back text).
    let question: String
    /// The correct answer (the opposite text of the question).
    let correctAnswer: String
    /// An array of answer options.
    let options: [String]
    /// A flag indicating whether the front text is shown as the question.
    let showingFront: Bool
    
    /// Initializes a new instance of QuizModelCard.
    /// - Parameters:
    ///   - correctWord: The DatabaseModelWord used as the basis for the card.
    ///   - allWords: An array of DatabaseModelWord objects used to extract answer options.
    ///   - showingFront: A Boolean value that determines if the question is based on the front text.
    init(correctWord: DatabaseModelWord, allWords: [DatabaseModelWord], showingFront: Bool) {
        self.showingFront = showingFront
        self.question = showingFront ? correctWord.frontText : correctWord.backText
        self.correctAnswer = showingFront ? correctWord.backText : correctWord.frontText
        self.options = allWords.map { showingFront ? $0.backText : $0.frontText }
    }
}
