import SwiftUI

enum DiscoverTheme: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    static func fromString(_ string: String) -> DiscoverTheme {
        return DiscoverTheme(rawValue: string) ?? .light
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
