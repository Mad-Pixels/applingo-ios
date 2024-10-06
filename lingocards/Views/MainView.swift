import SwiftUI

struct MainView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @State private var selectedTab = 0
    @State private var viewID = UUID()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TabLearnView()
                .id(viewID)
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabLearn")))
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
                .tag(0)
            
            TabDictionariesView()
                .id(viewID)
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabDictionaries")))
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
                .tag(1)
            
            TabWordsView()
                .id(viewID)
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabWords")))
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
                .tag(2)
            
            TabSettingsView()
                .id(viewID)
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(languageManager.localizedString(for: "TabSettings")))
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
                .tag(3)
        }
        .onReceive(NotificationCenter.default.publisher(for: LanguageManager.languageChangeNotification)) { _ in
            viewID = UUID() // Это вызовет обновление содержимого вкладок без изменения выбранной вкладки
        }
    }
    
    func capitalizeFirstLetter(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
