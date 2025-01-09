import SwiftUI

 struct ThemeSection: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        AppPicker(
            selectedValue: $themeManager.currentTheme,
            items: themeManager.supportedThemes,
            title: "theme",
            style: .segmented,
            onChange: { newTheme in
                themeManager.setTheme(to: newTheme)
            }
        ) { theme in
            Text(theme.asString)
        }
    }
}
