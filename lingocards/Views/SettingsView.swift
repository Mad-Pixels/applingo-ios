import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var settingsManager: SettingsManager

    var body: some View {
        Form {
            Section(header: Text("Language")) {
                Picker("Language", selection: $settingsManager.settings.language) {
                    Text("English").tag("en")
                    Text("Русский").tag("ru")
                    // Добавьте другие языки по необходимости
                }
                .onChange(of: settingsManager.settings.language) { newValue in
                    appState.localizationManager.setLanguage(newValue)
                }
            }

            Section(header: Text("Theme")) {
                Picker("Theme", selection: $settingsManager.settings.theme) {
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .onChange(of: settingsManager.settings.theme) { newValue in
                    appState.themeManager.setTheme(newValue)
                }
            }

            Section(header: Text("Logging")) {
                Toggle(isOn: $settingsManager.settings.sendLogs) {
                    Text("Send Logs")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
