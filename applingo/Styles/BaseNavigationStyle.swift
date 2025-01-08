import SwiftUI

struct BaseNavigationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarColorScheme(ThemeManager.shared.currentThemeStyle is DarkTheme ? .dark : .light, for: .navigationBar)
    }
}
