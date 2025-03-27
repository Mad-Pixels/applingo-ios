import SwiftUI

/// Модель представляющая карточку для свайпа, которая содержит вопрос, правильный ответ и информацию о паре слов.
struct SwipeModelCard {
    let word: DatabaseModelWord
    /// Текст, который отображается в верхней части карточки (frontText)
    let frontText: String
    /// Текст, который отображается в нижней части карточки (backText)
    let backText: String
    /// Флаг, указывающий является ли пара правильной (frontText и backText от одного слова)
    let isCorrectPair: Bool
    /// Слово, из которого взят backText (может отличаться от word если isCorrectPair == false)
    let backWord: DatabaseModelWord
    
    /// Инициализирует новый экземпляр SwipeModelCard.
    /// - Parameters:
    ///   - word: DatabaseModelWord используемое как основа для карточки (для frontText)
    ///   - allWords: Массив слов для выбора backText
    ///   - forceCorrect: Флаг, указывающий нужно ли создать правильную пару
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], forceCorrect: Bool? = nil) {
        self.word = word
        self.frontText = word.frontText
        
        // Определяем, будет ли пара правильной (случайно или принудительно)
        let shouldBeCorrect = forceCorrect ?? Bool.random()
        
        if shouldBeCorrect {
            // Правильная пара - берем backText из того же слова
            self.backText = word.backText
            self.backWord = word
            self.isCorrectPair = true
        } else {
            // Неправильная пара - берем backText из другого слова
            let otherWords = allWords.filter { $0.id != word.id }
            if let randomWord = otherWords.randomElement() {
                self.backText = randomWord.backText
                self.backWord = randomWord
                self.isCorrectPair = false
            } else {
                // Если нет других слов, используем то же самое слово
                self.backText = word.backText
                self.backWord = word
                self.isCorrectPair = true
            }
        }
    }
}
