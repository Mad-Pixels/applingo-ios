import Foundation
import SwiftUI

/// Протокол для управления темами
protocol ThemeManagerProtocol: ObservableObject {
    var currentTheme: Theme { get }
    func toggleTheme()
}

/// Класс для управления темами
class ThemeManager: ObservableObject {
    @Published private(set) var currentTheme: Theme
    let logger: LoggerProtocol

    init(logger: LoggerProtocol, initialTheme: String) {
        self.logger = logger
        // Устанавливаем тему на основе переданного параметра
        switch initialTheme {
        case "dark":
            self.currentTheme = DarkTheme()
        default:
            self.currentTheme = LightTheme()
        }
        applyTheme()
    }

    func setTheme(_ theme: String) {
        switch theme {
        case "dark":
            currentTheme = DarkTheme()
        default:
            currentTheme = LightTheme()
        }
        logger.log("Theme changed to \(theme)", level: .info, details: nil)
        objectWillChange.send()
        applyTheme()
    }

    func toggleTheme() {
        let newTheme = currentTheme is LightTheme ? "dark" : "light"
        setTheme(newTheme)
    }

    private func applyTheme() {
        // Применение темы к глобальным UI элементам, если необходимо
    }
}
