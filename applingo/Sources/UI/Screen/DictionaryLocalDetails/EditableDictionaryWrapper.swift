import SwiftUI

/// A wrapper for the dictionary model to enable editing.
/// It encapsulates a DatabaseModelDictionary instance.
class EditableDictionaryWrapper: ObservableObject {
    @Published var dictionary: DatabaseModelDictionary
    
    /// Initializes the wrapper with a given dictionary.
    /// - Parameter dictionary: The dictionary model to wrap.
    init(dictionary: DatabaseModelDictionary) {
        self.dictionary = dictionary
    }
}
