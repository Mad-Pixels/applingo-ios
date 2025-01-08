import SwiftUI

struct BaseNavigationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarColorScheme(ThemeManager.shared.currentThemeStyle is PaletteThemeDark ? .dark : .light, for: .navigationBar)
    }
}
