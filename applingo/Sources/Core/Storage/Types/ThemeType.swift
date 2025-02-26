import SwiftUI

/// Enum representing available themes in the app.
enum ThemeType: String, CaseIterable {
    // MARK: - Cases
    
    /// Light theme.
    case light = "Light"
    /// Dark theme.
    case dark = "Dark"
    
    // MARK: - Methods
    
    /// Converts a string into a `ThemeType`.
    /// - Parameter string: The string to convert.
    /// - Returns: A `ThemeType` corresponding to the string, or `.light` as the default.
    static func fromString(_ string: String) -> ThemeType {
        return ThemeType(rawValue: string) ?? .light
    }

    /// Converts the `ThemeType` to a string representation.
    var asString: String {
        return self.rawValue
    }

    /// Maps the `ThemeType` to the corresponding `ColorScheme`.
    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
