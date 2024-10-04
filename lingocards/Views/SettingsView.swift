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
                // No need for .onChange here
            }

            // Language Selection
            Section(header: Text("Language")) {
                Picker("Select Language", selection: $appState.language) {
                    ForEach(AppSettings.supportedLanguages, id: \.self) { language in
                        Text(language.uppercased()).tag(language)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                // No need for .onChange here
            }

            // Logging Toggle
            Section(header: Text("Logging")) {
                Toggle("Send Logs", isOn: $appState.sendLogs)
                // No need for .onChange here
            }
        }
        .navigationBarTitle("Settings", displayMode: .inline)
    }
}
