import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var logHandler = LogHandler.shared
    
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
                CompLogSenderToggleView(
                    sendLogs: $logHandler.sendLogs
                )
            }
            .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
        }
    }
}
