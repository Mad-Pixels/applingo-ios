import SwiftUI

class WordWrapper: ObservableObject {
    @Published var word: DatabaseModelWord
    
    init(word: DatabaseModelWord) {
        self.word = word
    }
}
