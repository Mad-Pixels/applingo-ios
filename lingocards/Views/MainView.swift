import SwiftUI

struct MainView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Learn").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(0)
            
            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Dictionaries").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(1)
            
            TabWordsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Words").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(2)
            
            TabSettingsView()
                .tabItem {
                    Label {
                        Text(languageManager.localizedString(for: "Settings").capitalizedFirstLetter)
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(3)
        }
        .preferredColorScheme(themeManager.currentTheme == .dark ? .dark : .light)
    }
}
