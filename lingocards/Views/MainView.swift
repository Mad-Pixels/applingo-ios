import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = CounterViewModel()
    
    var body: some View {
        TabView {
            TabLearnView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(NSLocalizedString("TabLearn", comment: "")))
                    } icon: {
                        Image(systemName: "book.fill")
                    }
                }
            
            TabDictionariesView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(NSLocalizedString("TabDictionaries", comment: "")))
                    } icon: {
                        Image(systemName: "folder.fill")
                    }
                }
            TabWordsView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(NSLocalizedString("TabWords", comment: "")))
                    } icon: {
                        Image(systemName: "textformat")
                    }
                }
            TabSettingsView()
                .tabItem {
                    Label {
                        Text(capitalizeFirstLetter(NSLocalizedString("TabSettings", comment: "")))
                    } icon: {
                        Image(systemName: "gearshape.fill")
                    }
                }
        }
    }
    
    func capitalizeFirstLetter(_ string: String) -> String {
        return string.prefix(1).uppercased() + string.dropFirst()
    }
}
