import SwiftUI

struct LocalizedString {
    let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var localized: String {
        LocaleManager.shared.localizedString(for: key).capitalizedFirstLetter
    }
}
