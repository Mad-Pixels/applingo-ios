import SwiftUI

struct QuizCard {
    let question: String      // Текст вопроса (frontText или backText)
    let correctAnswer: String // Правильный ответ (противоположный текст)
    let options: [String]     // Все варианты ответов
    let showingFront: Bool    // Показываем ли frontText в вопросе
    
    init(correctWord: WordItemModel, allWords: [WordItemModel], showingFront: Bool) {
        self.showingFront = showingFront
        self.question = showingFront ? correctWord.frontText : correctWord.backText
        self.correctAnswer = showingFront ? correctWord.backText : correctWord.frontText
        self.options = allWords.map { showingFront ? $0.backText : $0.frontText }
    }
}
