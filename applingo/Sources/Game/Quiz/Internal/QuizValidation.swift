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

        let normalizedAnswerParts = splitAndNormalize(answer)
        let normalizedCorrectParts = splitAndNormalize(card.answer)

        let asSet = Set(normalizedAnswerParts)
        let correctSet = Set(normalizedCorrectParts)

        if asSet == correctSet || normalize(answer) == normalize(card.answer) {
            return .correct
        } else {
            return .incorrect
        }
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
        let stripped = lowered.applyingTransform(.stripDiacritics, reverse: false) ?? lowered

        let punctuationSet = CharacterSet.punctuationCharacters
        let invisibleSet = CharacterSet(charactersIn: "\u{200B}\u{200E}\u{200F}\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}")
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)

        let filtered = stripped.unicodeScalars.filter { scalar in
            allowedCharacters.contains(scalar) &&
            !punctuationSet.contains(scalar) &&
            !invisibleSet.contains(scalar)
        }

        return String(String.UnicodeScalarView(filtered)).trimmingCharacters(in: .whitespaces)
    }
    
    private func splitAndNormalize(_ text: String) -> [String] {
        return text
            .components(separatedBy: CharacterSet(charactersIn: ",;"))
            .map { normalize($0) }
            .filter { !$0.isEmpty }
    }
}
