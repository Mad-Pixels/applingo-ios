import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var languageManager = LanguageManager.shared
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
                errorType: .database,
                errorMessage: "Failed connect to database",
                localizedMessage: "asd",
                additionalInfo: ["error": "\(error.localizedDescription)"]
            )
            ErrorManager.shared.setError(appError: appError, frame: .main, source: .initialization)
        }
        APIManager.configure(baseURL: apiUrl, token: apiToken)
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
