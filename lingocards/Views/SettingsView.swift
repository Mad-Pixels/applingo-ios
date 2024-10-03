import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Language")) {
                    Picker("Language", selection: $appState.settingsManager.settings.language) {
                        Text("English").tag("en")
                        Text("Русский").tag("ru")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Theme")) {
                    Picker("Theme", selection: $appState.settingsManager.settings.theme) {
                        Text("Light").tag("light")
                        Text("Dark").tag("dark")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Logging")) {
                    Toggle(isOn: $appState.settingsManager.settings.sendLogs) {
                        Text("Send Logs")
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .background(themeManager.currentTheme.backgroundColor)
        }
    }
}
