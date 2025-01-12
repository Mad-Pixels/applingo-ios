import SwiftUI

struct ThemeTracker: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .id(themeManager.currentTheme)
    }
}

extension View {
    func withThemeTracker() -> some View {
        modifier(ThemeTracker())
    }
}
