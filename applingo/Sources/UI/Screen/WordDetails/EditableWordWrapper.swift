import SwiftUI

/// A wrapper for the word model that allows for editing in the UI.
class WordWrapper: ObservableObject {
    @Published var word: DatabaseModelWord
    
    /// Initializes the wrapper with a given word model.
    /// - Parameter word: The word model to wrap.
    init(word: DatabaseModelWord) {
        self.word = word
    }
}
