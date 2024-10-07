import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            Form {
                CompThemePickerView(
                    selectedTheme: $themeManager.currentTheme,
                    supportedThemes: themeManager.supportedThemes,
                    onThemeChange: { newTheme in
                        themeManager.setTheme(to: newTheme)
                    }
                )

                CompLanguagePickerView(
                    selectedLanguage: $languageManager.currentLanguage,
                    supportedLanguages: languageManager.supportedLanguages,
                    displayName: languageManager.displayName(for:)
                )
            }
            .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
        }
    }
}
