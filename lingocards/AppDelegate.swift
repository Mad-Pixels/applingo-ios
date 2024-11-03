import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var frameManager = FrameManager.shared

    init() {
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

        Logger.initializeLogger()
        do {
            try DatabaseManager.shared.connect()
        } catch {
            fatalError("Не удалось подключиться к базе данных: \(error)")
        }
        APIManager.configure(baseURL: "https://lingocards-api.madpixels.io", token: "t9DbIipRtzPBVXYLoXxc6KSn")
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(languageManager)
                .environmentObject(errorManager)
                .environmentObject(themeManager)
                .environmentObject(frameManager)
                .environmentObject(DatabaseManager.shared)
        }
    }
}
