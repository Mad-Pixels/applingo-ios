// LingoCardsApp.swift
import SwiftUI

@main
struct LingoCardsApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(appState.localizationManager)
                .environmentObject(appState.themeManager)
        }
    }
}

