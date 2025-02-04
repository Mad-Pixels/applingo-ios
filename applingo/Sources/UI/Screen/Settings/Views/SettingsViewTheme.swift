import SwiftUI

/// A view that displays the theme selection section in Settings.
struct SettingsViewTheme: View {
    
    // MARK: - Environment and State Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var locale = SettingsLocale()
    
    // MARK: - Body
    
    var body: some View {
        ItemPicker(
            selectedValue: $themeManager.currentTheme,
            items: themeManager.supportedThemes,
            title: locale.screenSubtitleTheme,
            style: .themed(themeManager.currentThemeStyle, type: .segmented),
            onChange: { newTheme in
                themeManager.setTheme(to: newTheme)
            }
        ) { theme in
            Text(theme.asString)
        }
    }
}
