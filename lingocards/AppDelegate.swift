import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager()
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var tabManager = TabManager.shared
    
    init() {
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

        Logger.initializeLogger()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(languageManager)
                .environmentObject(errorManager)
                .environmentObject(themeManager)
                .environmentObject(tabManager)
        }
    }
}
