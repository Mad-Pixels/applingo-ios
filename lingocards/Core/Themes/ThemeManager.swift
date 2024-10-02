import Foundation
import UIKit

protocol ThemeManagerProtocol {
    var currentTheme: Theme { get }
    func setTheme(_ theme: String)
}

class ThemeManager: ThemeManagerProtocol {
    private(set) var currentTheme: Theme
    
    init() {
        self.currentTheme = LightTheme()
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
