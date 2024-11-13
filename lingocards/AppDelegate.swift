import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var gameSpecialManager = GameSpecialManager.shared
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var frameManager = FrameManager.shared
    
    private let apiUrl = "https://lingocards-api.madpixels.io"
    private let apiToken = "t9DbIipRtzPBVXYLoXxc6KSn"
    private let dbName = "LingocardDB.sqlite"

    init() {
        Logger.initializeLogger()
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

        do {
            try DatabaseManager.shared.connect(dbName: "LingocardDB.sqlite")
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: "Failed to connect to database",
                localized: LanguageManager.shared.localizedString(for: "ErrMain").capitalizedFirstLetter,
                original: error,
                additional: ["error": error.localizedDescription]
            )
            ErrorManager.shared.setError(appError: appError, frame: .main, source: .initialization)
        }
        APIManager.configure(baseURL: apiUrl, token: apiToken)
        _ = RepositoryCache.shared
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
