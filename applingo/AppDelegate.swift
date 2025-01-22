import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var hapticManager = HardwareHaptic.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var errorManager = ErrorManager1.shared
    //@StateObject private var frameManager = FrameManager.shared
    
    private let apiUrl = GlobalConfig.apiURL
    private let apiToken = GlobalConfig.apiToken
    private let dbName = "LingocardDB.sqlite"

    init() {
        do {
            try AppDatabase.shared.connect(dbName: dbName)
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: "Failed to connect to database",
                localized: LanguageManager.shared.localizedString(for: "ErrMain").capitalizedFirstLetter,
                original: error,
                additional: ["error": error.localizedDescription]
            )
            ErrorManager1.shared.setError(appError: appError, frame: .main, source: .initialization)
        }
        
        
        Logger.initializeLogger()
        do {
            try DatabaseManager.shared.connect(dbName: dbName)
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: "Failed to connect to database",
                localized: LanguageManager.shared.localizedString(for: "ErrMain").capitalizedFirstLetter,
                original: error,
                additional: ["error": error.localizedDescription]
            )
            ErrorManager1.shared.setError(appError: appError, frame: .main, source: .initialization)
        }
        APIManager.configure(baseURL: apiUrl, token: apiToken)
        _ = RepositoryCache.shared
    }

    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(languageManager)
                .environmentObject(errorManager)
                .environmentObject(themeManager)
                //.environmentObject(frameManager)
                .environmentObject(DatabaseManager.shared)
        }
    }
}
