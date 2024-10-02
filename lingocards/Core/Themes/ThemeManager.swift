import Foundation
import UIKit

protocol ThemeManagerProtocol {
    var currentTheme: Theme { get }
    func setTheme(_ theme: String)
}

class ThemeManager: ThemeManagerProtocol {
    let logger: LoggerProtocol
    private(set) var currentTheme: Theme
    
    init(logger: LoggerProtocol) {
        self.currentTheme = LightTheme()
        self.logger = logger
    }
    
    func setTheme(_ theme: String) {
        switch theme {
        case "dark":
            currentTheme = DarkTheme()
        default:
            currentTheme = LightTheme()
        }
        applyTheme()
    }
    
    private func applyTheme() {
        // Применение темы к глобальным UI элементам
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
            // Дополнительные настройки темы...
        }
    }
}
