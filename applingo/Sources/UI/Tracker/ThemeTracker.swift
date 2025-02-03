import SwiftUI

// MARK: - ThemeTracker ViewModifier
/// Applies the current theme and background to the view.
struct ThemeTracker: ViewModifier {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .id(themeManager.currentTheme)
    }
}

// Extension for easier usage of ThemeTracker
extension View {
    func withThemeTracker() -> some View {
        modifier(ThemeTracker())
    }
}
