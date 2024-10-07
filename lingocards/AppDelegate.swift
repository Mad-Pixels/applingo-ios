import SwiftUI

@main
struct LingocadrdApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var themeManager = ThemeManager()
    @State private var viewID = UUID()
    
    init() {
        Logger.initializeLogger()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(languageManager)
                .environmentObject(themeManager)
                .id(viewID)
                .onReceive(NotificationCenter.default.publisher(for: LanguageManager.languageChangeNotification)) { _ in
                    viewID = UUID()
                }
        }
    }
}
