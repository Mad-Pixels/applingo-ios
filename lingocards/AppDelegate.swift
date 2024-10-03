import SwiftUI

@main
struct LingoCardsApp: App {
    // Используем уже существующий экземпляр AppState через shared
    @StateObject private var appState = AppState.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState.localizationManager)
                .environmentObject(appState.themeManager)
                .environmentObject(appState)
        }
    }
}
