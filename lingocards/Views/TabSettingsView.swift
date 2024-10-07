import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var logHandler = LogHandler.shared  // Добавляем наблюдение за состоянием LogHandler
    
    var body: some View {
        NavigationView {
            Form {
                // Секция для выбора темы приложения
                CompThemePickerView(
                    selectedTheme: $themeManager.currentTheme,
                    supportedThemes: themeManager.supportedThemes,
                    onThemeChange: { newTheme in
                        themeManager.setTheme(to: newTheme)
                    }
                )
                
                // Секция для выбора языка приложения
                CompLanguagePickerView(
                    selectedLanguage: $languageManager.currentLanguage,
                    supportedLanguages: languageManager.supportedLanguages,
                    displayName: languageManager.displayName(for:)
                )
                
                // Секция для включения/выключения отправки логов
                Section(header: Text(languageManager.localizedString(for: "Log Settings"))) {
                    Toggle(isOn: $logHandler.sendLogs) {
                        Text(languageManager.localizedString(for: "Enable Log Sending"))
                    }
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
        }
    }
}
