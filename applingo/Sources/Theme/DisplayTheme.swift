import SwiftUI

enum DisplayTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    static func fromString(_ string: String) -> DisplayTheme {
        return DisplayTheme(rawValue: string) ?? .light
    }

    var asString: String {
        return self.rawValue
    }

    var colorScheme: ColorScheme {
        switch self {
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
