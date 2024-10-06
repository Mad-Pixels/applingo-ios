import SwiftUI

@main
struct LingocadrdApp: App {
    @StateObject private var languageManager = LanguageManager()
    @State private var viewID = UUID()
    
    init() {
        Logger.initializeLogger()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(languageManager)
                .id(viewID)
                .onReceive(NotificationCenter.default.publisher(for: LanguageManager.languageChangeNotification)) { _ in
                    viewID = UUID()
                }
        }
    }
}
