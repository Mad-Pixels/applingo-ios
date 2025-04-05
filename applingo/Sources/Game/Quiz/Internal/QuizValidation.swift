import SwiftUI

internal final class QuizValidation: BaseGameValidation {
    private var currentCard: QuizModelCard?
    private var currentWord: DatabaseModelWord?
    
    func setCurrentCard(currentCard: QuizModelCard, currentWord: DatabaseModelWord) {
        self.currentCard = currentCard
        self.currentWord = currentWord
    }
    
    override func validateAnswer(answer: Any) -> GameValidationResult {
        guard let answer = answer as? String,
              let card = currentCard else {
            return .incorrect
        }
        print("ZZZZZZZZZ")
        print(normalize(answer), normalize(card.answer))
        return normalize(answer) == normalize(card.answer) ? .correct : .incorrect
    }
    
    override func getCurrentWord() -> DatabaseModelWord? {
        return currentWord
    }
    
    override func getCorrectAnswer() -> String? {
        return currentCard?.answer
    }

    /// Normalize input: lowercased + diacritic stripped (but keep spaces and punctuation)
    private func normalize(_ text: String) -> String {
        let lowered = text.lowercased()
        
        // Удаляем диакритики
        let stripped = lowered.applyingTransform(.stripDiacritics, reverse: false) ?? lowered
        
        // Удаляем невидимые и форматные символы
        let invisibleSet = CharacterSet(charactersIn: "\u{200B}\u{200E}\u{200F}\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}")
        
        let filtered = stripped.unicodeScalars.filter { scalar in
            !CharacterSet.controlCharacters.contains(scalar) &&
            !CharacterSet.nonBaseCharacters.contains(scalar) &&
            !invisibleSet.contains(scalar)
        }
        
        return String(String.UnicodeScalarView(filtered))
    }
}
