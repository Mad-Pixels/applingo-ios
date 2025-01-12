import SwiftUI


struct MainView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab: Int = 0

    var body: some View {
        AppViewTab(theme: themeManager.currentTheme, style: .default) {
            TabView(selection: $selectedTab) {
                ScreenLearn()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Learn").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "book.fill")
                        }
                    }
                    .tag(0)

                WordList()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "textformat")
                        }
                    }
                    .tag(1)

                DictionaryLocalList()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "folder.fill")
                        }
                    }
                    .tag(2)

                ScreenSettings()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "gearshape.fill")
                        }
                    }
                    .tag(3)
            }
        }
    }
}


