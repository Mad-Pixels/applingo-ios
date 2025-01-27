import Foundation

/// Enum representing supported locales in the app.
enum LocaleType: String, CaseIterable {
    // MARK: - Cases
    
    /// English locale.
    case english = "en"
    /// Russian locale.
    case russian = "ru"
    
    // MARK: - Methods
    
    /// Converts a string into a `LocaleType`.
    /// - Parameter string: The string to convert.
    /// - Returns: A `LocaleType` corresponding to the string, or `.english` as the default.
    static func fromString(_ string: String) -> LocaleType {
        return LocaleType(rawValue: string) ?? .english
    }
    
    /// Converts the `LocaleType` to a string representation.
    var asString: String {
        return self.rawValue
    }
    
    /// Provides the localized display name of the locale.
    /// - Example: For `"en"`, returns `"english"` (based on system localization).
    var displayName: String {
        Locale(identifier: self.rawValue)
            .localizedString(forIdentifier: self.rawValue)?.lowercased() ?? self.rawValue
    }
}
