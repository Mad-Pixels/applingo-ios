import SwiftUI

final class ThemeProvider {
    static let shared = ThemeProvider()
    
    func currentTheme() -> ThemeStyle {
        switch ThemeManager().currentTheme {
        case .dark:
            return PaletteThemeDark()
        case .light:
            return PaletteThemeLight()
        }
    }
}
