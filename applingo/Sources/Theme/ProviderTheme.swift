import SwiftUI

final class ProviderTheme {
    static let shared = ProviderTheme()
    
    func currentTheme() -> AppTheme {
        switch ThemeManager().currentTheme {
        case .dark:
            return PaletteThemeDark()
        case .light:
            return PaletteThemeLight()
        }
    }
}
