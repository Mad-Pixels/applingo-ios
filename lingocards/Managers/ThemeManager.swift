import SwiftUI
import Combine

enum ThemeType: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    static func fromString(_ string: String) -> ThemeType {
        return ThemeType(rawValue: string) ?? .light
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

final class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeType

    // Используем инициализатор для задания темы из Defaults
    init() {
        let initialTheme = ThemeType.fromString(Defaults.appTheme ?? ThemeType.light.rawValue)
        self.currentTheme = initialTheme
        Logger.debug("[ThemeManager]: Initialized with theme \(self.currentTheme.rawValue)")
    }

    func switchTheme(to theme: ThemeType) {
        print("FOOO")
        Logger.debug("[ThemeManager]: Switching theme to \(theme.rawValue)")
        self.currentTheme = theme
        Defaults.appTheme = theme.rawValue  // Сохраняем значение темы в UserDefaults через Defaults
    }
}
