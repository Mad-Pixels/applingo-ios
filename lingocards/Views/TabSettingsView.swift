import SwiftUI

struct TabSettingsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager
    
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
                        onThemeChange: { newTheme in themeManager.setTheme(to: newTheme) },
                        theme: theme
                    )
                    CompPickerView(
                        selectedValue: $languageManager.currentLanguage,
                        items: languageManager.supportedLanguages,
                        title: languageManager.localizedString(for: "Language"),
                        theme: theme
                    ) { language in
                        Text(languageManager.displayName(for: language).capitalizedFirstLetter)
                    }
                    CompLogSenderToggleView(
                        sendLogs: $logHandler.sendLogs,
                        theme: theme
                    )
                }
                .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .modifier(BaseNavigationStyle(theme: theme))
            }
            .onAppear {
                tabManager.setActiveTab(.settings)
            }
            .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
                if newTab != .learn {
                    tabManager.deactivateTab(.learn)
                }
            })
        }
    }
}
