import SwiftUI

struct QuizModelCard {
    let word: DatabaseModelWord
    
    let question: String
    let answer: String
    let options: [String]
    let voice: Bool
    let flip: Bool
    
    init(word: DatabaseModelWord, allWords: [DatabaseModelWord], flip: Bool = false, voice: Bool = false) {
        self.word = word
        self.voice = voice
        self.flip = flip
        
        self.options = allWords.map { flip ? $0.backText : $0.frontText }
        
        if flip {
            self.question = word.frontText
            self.answer = word.backText
        } else {
            self.question = word.backText
            self.answer = word.frontText
        }
    }
}
