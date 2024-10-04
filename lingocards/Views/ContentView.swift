import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }

            DictionariesView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Dictionaries")
                }

            WordsView()
                .tabItem {
                    Image(systemName: "textformat")
                    Text("Words")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .preferredColorScheme(appState.theme == "dark" ? .dark : .light)
        .onAppear {
            appState.applyTheme(appState.theme)
            appState.applyLanguage(appState.language)
        }
        .environmentObject(appState) // Ensure all subviews have access
    }
}
