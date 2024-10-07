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
                        ForEach(ThemeType.allCases, id: \.self) { theme in
                            Text(theme.rawValue).tag(theme)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle()) // Используем SegmentedPicker для выбора темы
                }
                
                // Секция для выбора языка
                CompLanguagePickerView(
                    selectedLanguage: $languageManager.currentLanguage,
                    supportedLanguages: languageManager.supportedLanguages,
                    displayName: languageManager.displayName(for:)
                )
            }
            .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
            .preferredColorScheme(themeManager.currentTheme.colorScheme) // Применяем текущую цветовую схему
        }
    }
}
