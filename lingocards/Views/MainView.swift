import SwiftUI

struct MainView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabLearn")))
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(0)
            
            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabDictionaries")))
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(1)
            
            TabWordsView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabWords")))
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(2)
            
            TabSettingsView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabSettings")))
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(3)
        }
    }
    
    func capitalizeFirstLetter(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
