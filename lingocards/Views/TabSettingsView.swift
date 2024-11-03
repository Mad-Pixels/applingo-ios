import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @ObservedObject var logHandler = LogHandler.shared

    var body: some View {
        let theme = themeManager.currentThemeStyle

        NavigationView {
            ZStack {
                theme.backgroundViewColor.edgesIgnoringSafeArea(.all)
                
                Form {
                    CompThemePickerView(
                        selectedTheme: $themeManager.currentTheme,
                        supportedThemes: themeManager.supportedThemes,
                        onThemeChange: { newTheme in themeManager.setTheme(to: newTheme) }
                    )
                    CompPickerView(
                        selectedValue: $languageManager.currentLanguage,
                        items: languageManager.supportedLanguages,
                        title: languageManager.localizedString(for: "Language")
                    ) { language in
                        Text(languageManager.displayName(for: language).capitalizedFirstLetter)
                    }
                    CompLogSenderToggleView(
                        sendLogs: $logHandler.sendLogs
                    )
                }
                .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .modifier(BaseNavigationStyle())
            }
            .onAppear {
                FrameManager.shared.setActiveFrame(.tabSettings)
            }
        }
    }
}
