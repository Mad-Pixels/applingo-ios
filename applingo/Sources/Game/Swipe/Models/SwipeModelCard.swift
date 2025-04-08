import SwiftUI

struct SwipeModelCard {
    let id = UUID()
    
    let word: DatabaseModelWord
    let backWord: DatabaseModelWord

    let frontText: String
    let backText: String
    let isCorrectPair: Bool
    
    let isSpecialCard: Bool
    let specialBonus: GameSpecialBonus?

    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], forceCorrect: Bool? = nil) {
        self.frontText = word.frontText
        self.word = word

        let shouldBeCorrect = forceCorrect ?? Bool.random()

        if shouldBeCorrect {
            self.backText = word.backText
            self.backWord = word
            self.isCorrectPair = true
        } else {
            let otherWords = allWords.filter { $0.id != word.id }
            if let randomWord = otherWords.randomElement() {
                self.backText = randomWord.backText
                self.backWord = randomWord
                self.isCorrectPair = false
            } else {
                self.backText = word.backText
                self.backWord = word
                self.isCorrectPair = true
            }
        }

        let bonus = SwipeSpecial.shared.maybeGetRandomBonus(chance: SPECIAL_CARD_CHANCE)
        self.specialBonus = bonus
        self.isSpecialCard = bonus != nil
    }
}
