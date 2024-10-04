import SwiftUI

@main
struct LingoCardsApp: App {
    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(appState.localizationManager)
        }
    }
}
