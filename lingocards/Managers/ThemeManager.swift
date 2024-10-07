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
}

final class ThemeManager: ObservableObject {
    /// Текущая тема, которая обновляет все представления, подписанные на этот менеджер.
    @Published var currentTheme: ThemeType = ThemeType.fromString(Defaults.appTheme ?? ThemeType.light.rawValue) {
        didSet {
            Defaults.appTheme = currentTheme.asString // Сохраняем выбранную тему в UserDefaults как строку
        }
    }

    /// Переключает тему приложения.
    func switchTheme(to theme: ThemeType) {
        currentTheme = theme
    }
}
