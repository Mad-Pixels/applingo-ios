import SwiftUI

struct CompThemePickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedTheme: ThemeType
    
    var supportedThemes: [ThemeType]
    var onThemeChange: (ThemeType) -> Void

    var body: some View {
        Section(header: Text(languageManager.localizedString(for: "Theme"))) {
            Picker("Select Theme", selection: $selectedTheme) {
                ForEach(supportedThemes, id: \.self) { theme in
                    Text(theme.asString).tag(theme)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedTheme) { oldValue, newValue in
                if oldValue != newValue {
                    onThemeChange(newValue)
                }
            }
        }
    }
}
