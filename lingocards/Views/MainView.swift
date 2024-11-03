import SwiftUI

struct MainView: View {
    @EnvironmentObject var databaseManager: DatabaseManager
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject private var frameManager = FrameManager.shared

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
//                .onAppear {
//                    frameManager.setActiveFrame(.learn)
//                }

            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(AppFrameModel.tabDictionaries)
//                .onAppear {
//                    frameManager.setActiveFrame(.tabDictionaries)
//                }

            TabWordsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(AppFrameModel.tabWords)
//                .onAppear {
//                    frameManager.setActiveFrame(.tabWords)
//                }

            TabSettingsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(AppFrameModel.tabSettings)
//                .onAppear {
//                    frameManager.setActiveFrame(.tabSettings)
//                }
        }

        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
//        .modifier(FrameModifier(activeFrame: frameManager.activeFrame) { newFrame in
//            if newFrame != .learn {
//                frameManager.deactivateFrame(.learn)
//            }
//        })
    }
}
