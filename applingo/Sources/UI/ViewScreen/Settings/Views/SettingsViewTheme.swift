import SwiftUI

struct SettingsViewTheme: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Environment(\.settingsLocale) private var locale
    
    var body: some View {
        ItemPicker(
            selectedValue: $themeManager.currentTheme,
            items: themeManager.supportedThemes,
            title: locale.themeTitle,
            style: .themed(themeManager.currentThemeStyle, type: .segmented),
            onChange: { newTheme in
                themeManager.setTheme(to: newTheme)
            }
        ) { theme in
            Text(theme.asString)
        }
    }
}
