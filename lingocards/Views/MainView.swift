import SwiftUI

struct MainView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TabView {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Learn").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(AppFrameModel.learn)

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(AppFrameModel.tabDictionaries)

            TabWordsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(AppFrameModel.tabWords)

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(AppFrameModel.tabSettings)
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }
}
