import SwiftUI

// Used in Base views.

/// A ViewModifier that applies the current theme settings to the view.
/// It sets the preferred color scheme based on the current theme,
/// applies the primary background from the theme style,
/// and uses the theme as the view's identity (using .id) so that updates trigger a refresh.
struct TrackerThemeModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
            .background(themeManager.currentThemeStyle.backgroundPrimary)
            .id(themeManager.currentTheme)
    }
}
