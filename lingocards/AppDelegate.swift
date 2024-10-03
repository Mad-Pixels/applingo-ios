import SwiftUI

@main
struct LingoCardsApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView(apiManager: appState.apiManager)
                .environmentObject(appState)
        }
    }
}
