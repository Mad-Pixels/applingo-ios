import SwiftUI

class WordWrapper: ObservableObject {
    @Published var word: WordItemModel
    
    init(word: WordItemModel) {
        self.word = word
    }
}
