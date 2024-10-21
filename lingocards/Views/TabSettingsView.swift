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
                theme.backgroundColor.edgesIgnoringSafeArea(.all)
                
                Form {
                    CompThemePickerView(
                        selectedTheme: $themeManager.currentTheme,
                        supportedThemes: themeManager.supportedThemes,
                        onThemeChange: { newTheme in
                            themeManager.setTheme(to: newTheme)
                        },
                        theme: theme
                    )
                    .modifier(FormItemStyle(theme: theme))
                    
                    CompLanguagePickerView(
                        selectedLanguage: $languageManager.currentLanguage,
                        supportedLanguages: languageManager.supportedLanguages,
                        displayName: languageManager.displayName(for:),
                        theme: theme
                    )
                    .modifier(FormItemStyle(theme: theme))
                    
                    CompLogSenderToggleView(
                        sendLogs: $logHandler.sendLogs,
                        theme: theme
                    )
                    .modifier(FormItemStyle(theme: theme))
                }
                .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large)
                .modifier(NavigationBarStyle(theme: theme))
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
