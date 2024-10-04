import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            // Theme Selection
            Section(header: Text("Theme")) {
                Picker("Select Theme", selection: $appState.theme) {
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                }
                .pickerStyle(SegmentedPickerStyle())
                .onChange(of: appState.theme) { newTheme in
                    appState.updateTheme(newTheme)
                }
            }

            // Language Selection
            Section(header: Text("Language")) {
                Picker("Select Language", selection: $appState.language) {
                    ForEach(AppSettings.supportedLanguages, id: \.self) { language in
                        Text(language.uppercased()).tag(language)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .onChange(of: appState.language) { newLanguage in
                    appState.updateLanguage(newLanguage)
                }
            }

            // Logging Toggle
            Section(header: Text("Logging")) {
                Toggle("Send Logs", isOn: $appState.sendLogs)
                    .onChange(of: appState.sendLogs) { newSendLogs in
                        appState.updateSendLogs(newSendLogs)
                    }
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}
