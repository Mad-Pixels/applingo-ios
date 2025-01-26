import SwiftUI

class EditableDictionaryWrapper: ObservableObject {
    @Published var dictionary: DatabaseModelDictionary
    
    init(dictionary: DatabaseModelDictionary) {
        self.dictionary = dictionary
    }
}
