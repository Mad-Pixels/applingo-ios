import SwiftUI

enum ThemeType: String, CaseIterable {
    case light = "Light"
    case dark = "Dark"
    
    // Метод преобразования строки в ThemeType
    static func fromString(_ string: String) -> ThemeType {
        return ThemeType(rawValue: string) ?? .light
    }
    
    // Сопоставление со строковым представлением
    var asString: String {
        return self.rawValue
    }
    
    // Сопоставление с ColorScheme для SwiftUI
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
    
    // Параметр currentTheme инициализируется в конструкторе
    init() {
        let initialTheme = Defaults.appTheme ?? ThemeType.light.rawValue
        self.currentTheme = ThemeType.fromString(initialTheme)
        Logger.debug("[ThemeManager]: Initialized with theme \(self.currentTheme.rawValue)")
    }

    // Метод для смены темы
    func switchTheme(to theme: ThemeType) {
        self.currentTheme = theme
        Defaults.appTheme = theme.rawValue // Сохраняем новое значение в UserDefaults
        Logger.debug("[ThemeManager]: Set theme to \(theme.rawValue)")
    }
}
