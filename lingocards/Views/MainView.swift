import SwiftUI

struct MainView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        TabView {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Learn").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(AppFrameModel.learn)

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(AppFrameModel.tabDictionaries)

            TabWordsView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(AppFrameModel.tabWords)

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(LanguageManager.shared.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(AppFrameModel.tabSettings)
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }
}
