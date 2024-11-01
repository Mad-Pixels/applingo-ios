import SwiftUI

struct MainView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject private var tabManager = TabManager.shared

    var body: some View {
        TabView(selection: $tabManager.activeTab) {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Learn").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(AppTab.learn)

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(AppTab.dictionaries)

            TabWordsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(AppTab.words)

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(AppTab.settings)
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
        .modifier(TabModifier(activeTab: tabManager.activeTab) { newTab in
            if newTab != .learn {
                tabManager.deactivateTab(.learn)
            }
        })
    }
}
