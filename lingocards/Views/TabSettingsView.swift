import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(languageManager.localizedString(for: "Language"))) {
                    Picker("Select Language", selection: $languageManager.currentLanguage) {
                        ForEach(languageManager.supportedLanguages, id: \.self) { language in
                            Text(languageManager.displayName(for: language))
                                .tag(language)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())  // Стилизация пикера
                }

                // Пример использования локализованной строки
                Section {
                    Text(languageManager.localizedString(for: "welcome_message"))
                }
            }
            .navigationTitle(languageManager.localizedString(for: "Settings"))
        }
    }
}
