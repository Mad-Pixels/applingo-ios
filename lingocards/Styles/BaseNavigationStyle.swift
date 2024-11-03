import SwiftUI

struct BaseNavigationStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarColorScheme(ThemeManager().currentThemeStyle is ThemeDark ? .dark : .light, for: .navigationBar)
    }
}
