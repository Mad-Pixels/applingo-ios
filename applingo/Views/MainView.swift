import SwiftUI

struct MainView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        AppViewTab(theme: themeManager.currentTheme, style: .default) {
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

                TabWordsView()
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "textformat")
                        }
                    }
                    .tag(AppFrameModel.tabWords)

                TabDictionariesView()
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "folder.fill")
                        }
                    }
                    .tag(AppFrameModel.tabDictionaries)

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
        }
        .onAppear {
            AppStorage.shared.activeScreen = .game
        }
    }
}
