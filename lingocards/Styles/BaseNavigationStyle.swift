import SwiftUI

struct BaseNavigationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarColorScheme(ThemeManager.shared.currentThemeStyle is ThemeDark ? .dark : .light, for: .navigationBar)
    }
}
