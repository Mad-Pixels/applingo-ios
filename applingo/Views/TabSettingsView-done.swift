//import SwiftUI
//
//struct TabSettingsView: View {
//    @EnvironmentObject var languageManager: LanguageManager
//    @EnvironmentObject var themeManager: ThemeManager
//    
//    @ObservedObject var logHandler = LogHandler.shared
//
//    var body: some View {
//        let theme = themeManager.currentThemeStyle
//
//        NavigationView {
//            ZStack {
//                theme.backgroundPrimary.edgesIgnoringSafeArea(.all)
//                
//                Form {
//                    CompSelectView(
//                        selectedValue: $themeManager.currentTheme,
//                        items: themeManager.supportedThemes,
//                        title: languageManager.localizedString(for: "Theme"),
//                        style: .segmented,
//                        onChange: { newTheme in
//                            themeManager.setTheme(to: newTheme)
//                        }
//                    ) { theme in
//                        Text(theme.asString)
//                    }
//                    CompPickerView(
//                        selectedValue: $languageManager.currentLanguage,
//                        items: languageManager.supportedLanguages,
//                        title: languageManager.localizedString(for: "Language")
//                    ) { language in
//                        Text(languageManager.displayName(for: language).capitalizedFirstLetter)
//                    }
//                    CompLogSenderToggleView(
//                        sendLogs: $logHandler.sendLogs
//                    )
//                }
//                .navigationTitle(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
//                .navigationBarTitleDisplayMode(.large)
//                .modifier(BaseNavigationStyle())
//            }
//            .onAppear {
//                AppStorage.shared.activeScreen = .settings
//            }
//        }
//    }
//}
