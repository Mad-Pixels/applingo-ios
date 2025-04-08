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

       let answerSet = Set(normalizedAnswerParts)
       let correctSet = Set(normalizedCorrectParts)

       if answerSet == correctSet || normalize(answer) == normalize(card.answer) {
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

   /// Normalizes a string by:
   /// - Lowercasing
   /// - Removing diacritics (accents, etc.)
   /// - Filtering out punctuation and invisible characters
   /// - Replacing hyphens and underscores with spaces
   /// - Keeping only letters and spaces
   private func normalize(_ text: String) -> String {
       let lowered = text.lowercased()
       let stripped = lowered.applyingTransform(.stripDiacritics, reverse: false) ?? lowered
       
       // Replace hyphens and underscores with spaces
       let withSpaces = stripped.replacingOccurrences(of: "-", with: " ")
                                .replacingOccurrences(of: "_", with: " ")

       let punctuationSet = CharacterSet.punctuationCharacters
       let invisibleSet = CharacterSet(charactersIn: "\u{200B}\u{200E}\u{200F}\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}")
       let allowedCharacters = CharacterSet.letters.union(.whitespaces)

       let filtered = withSpaces.unicodeScalars.filter { scalar in
           allowedCharacters.contains(scalar) &&
           !punctuationSet.contains(scalar) &&
           !invisibleSet.contains(scalar)
       }

       return String(String.UnicodeScalarView(filtered)).trimmingCharacters(in: .whitespaces)
   }

   /// Splits input string by `,` and `;`, normalizes each part, and removes empty results
   private func splitAndNormalize(_ text: String) -> [String] {
       return text
           .components(separatedBy: CharacterSet(charactersIn: ",;"))
           .map { normalize($0) }
           .filter { !$0.isEmpty }
   }
}
