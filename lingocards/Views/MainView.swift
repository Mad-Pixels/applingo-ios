import SwiftUI

struct MainView: View {
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
                .tag(Tab.learn)

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(Tab.dictionaries)

            TabWordsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(Tab.words)

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(Tab.settings)
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
        .onChange(of: tabManager.activeTab) { oldTab, newTab in
            Logger.debug("[MainView]: Active tab changed from \(oldTab) to \(newTab)")
        }
    }
}
