import SwiftUI

struct CompThemePickerView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @Binding var selectedTheme: ThemeType
    
    var supportedThemes: [ThemeType]
    var onThemeChange: (ThemeType) -> Void
    let theme: ThemeStyle

    var body: some View {
        Section(header: Text(languageManager.localizedString(for: "Theme"))
            .modifier(HeaderBlockTextStyle(theme: theme))) {
            
                Picker("Select Theme", selection: $selectedTheme) {
                    ForEach(supportedThemes, id: \.self) { themeOption in
                        Text(themeOption.asString)
                            .tag(themeOption)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
        }
    }
}
