import SwiftUI

/// A struct for handling localized strings in the app.
struct LocalizedString {
    // MARK: - Properties
    
    /// The key used to fetch the localized string.
    let key: String
    
    // MARK: - Initialization
    
    /// Initializes a `LocalizedString` with the provided key.
    /// - Parameter key: The localization key.
    init(_ key: String) {
        self.key = key
    }
    
    // MARK: - Computed Properties
    
    /// The localized version of the string with the first letter capitalized.
    var localized: String {
        LocaleManager.shared.localizedString(for: key).capitalizedFirstLetter
    }
}
