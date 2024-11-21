import SwiftUI
import IQKeyboardManagerSwift

struct APIConfig {
    static let baseURL: String = {
        guard let url = ProcessInfo.processInfo.environment["API_URL"] else {
            fatalError("API_URL not set in environment")
        }
        return url
    }()
    
    static let token: String = {
        guard let token = ProcessInfo.processInfo.environment["API_TOKEN"] else {
            fatalError("API_TOKEN not set in environment")
        }
        return token
    }()
}

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var hapticManager = HapticManager.shared
    @StateObject private var themeManager = ThemeManager.shared
    @StateObject private var errorManager = ErrorManager.shared
    @StateObject private var frameManager = FrameManager.shared
    
    private let apiUrl = APIConfig.baseURL
    private let apiToken = APIConfig.token
    private let dbName = "LingocardDB.sqlite"

    init() {
        Logger.initializeLogger()
        IQKeyboardManager.shared.resignOnTouchOutside = true
        IQKeyboardManager.shared.enable = true

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
