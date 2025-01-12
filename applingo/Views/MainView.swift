import SwiftUI

struct MainView: View {
    @ObservedObject private var languageManager = LanguageManager.shared
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        AppViewTab(theme: themeManager.currentTheme, style: .default) {
            TabView {
                //TabLearnView()
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
                    .tag(AppFrameModel.learn)

                //TabWordsView()
                ScreenWords()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "textformat")
                        }
                    }
                    .tag(AppFrameModel.tabWords)

                //TabDictionariesView()
                DictionaryListLocal()
                    .environmentObject(ThemeManager.shared)
                    .environmentObject(LocaleManager.shared)
                    .tabItem {
                        Label {
                            Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                        } icon: {
                            Image(systemName: "folder.fill")
                        }
                    }
                    .tag(AppFrameModel.tabDictionaries)

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
                    .tag(AppFrameModel.tabSettings)
            }
        }
        .onAppear {
            AppStorage.shared.activeScreen = .game
        }
    }
}
