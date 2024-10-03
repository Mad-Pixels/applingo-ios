import Foundation
import SwiftUI

/// Протокол для управления темами
protocol ThemeManagerProtocol: ObservableObject {
    var currentTheme: Theme { get }
    func toggleTheme()
}

/// Класс для управления темами
class ThemeManager: ThemeManagerProtocol {
    /// Текущее выбранная тема
    @Published private(set) var currentTheme: Theme
    /// Логгер для записи событий
    let logger: LoggerProtocol

    /// Инициализация с загрузкой сохраненной темы или использованием темы по умолчанию
    init(logger: LoggerProtocol) {
        self.logger = logger
        // Загружаем сохраненную тему из UserDefaults или используем светлую тему по умолчанию
        if let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") {
            switch savedTheme {
            case "dark":
                self.currentTheme = DarkTheme()
            default:
                self.currentTheme = LightTheme()
            }
        } else {
            self.currentTheme = LightTheme()
        }
        applyTheme()
    }

    /// Переключение темы
    func toggleTheme() {
        if currentTheme is LightTheme {
            currentTheme = DarkTheme()
            UserDefaults.standard.setValue("dark", forKey: "selectedTheme")
        } else {
            currentTheme = LightTheme()
            UserDefaults.standard.setValue("light", forKey: "selectedTheme")
        }
        logger.log("Theme changed to \(currentTheme is LightTheme ? "Light" : "Dark")", level: .info, details: nil)
        applyTheme()
    }

    /// Применение темы к приложению
    private func applyTheme() {
        // В SwiftUI изменение темы будет происходить автоматически через привязки
        // Если есть необходимость изменить глобальные настройки, можно сделать это здесь
    }
}
