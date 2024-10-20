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
                theme.backgroundColor
                    .edgesIgnoringSafeArea(.all) // Устанавливаем общий фон
                
                Form {
                    // Выбор темы
                    CompThemePickerView(
                        selectedTheme: $themeManager.currentTheme,
                        supportedThemes: themeManager.supportedThemes,
                        onThemeChange: { newTheme in
                            themeManager.setTheme(to: newTheme)
                        }
                    )
                    
                    // Выбор языка
                    CompLanguagePickerView(
                        selectedLanguage: $languageManager.currentLanguage,
                        supportedLanguages: languageManager.supportedLanguages,
                        displayName: languageManager.displayName(for:)
                    )
                    
                    // Переключатель отправки логов
                    CompLogSenderToggleView(
                        sendLogs: $logHandler.sendLogs
                    )
                }
                .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                .navigationBarTitleDisplayMode(.large) // Единый стиль заголовка
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
