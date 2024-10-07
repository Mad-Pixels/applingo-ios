import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var themeManager = ThemeManager()
    @State private var viewID = UUID()
    
    init() {
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

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
