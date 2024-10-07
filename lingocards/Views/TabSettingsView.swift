import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            Form {
                // Секция для выбора темы приложения
                Section(header: Text(languageManager.localizedString(for: "Theme"))) {
                    Picker("Select Theme", selection: $themeManager.currentTheme) {
                        ForEach(themeManager.supportedThemes, id: \.self) { theme in
                            Text(theme.asString).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: themeManager.currentTheme) { newTheme in
                        themeManager.setTheme(to: newTheme)
                    }
                }

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
