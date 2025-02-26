import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
//    @StateObject private var hapticManager = HardwareHaptic.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    private let dbName = "AppLingoDB.sqlite"
    private let apiUrl = GlobalConfig.apiURL
    private let apiToken = GlobalConfig.apiToken
    
    init() {
        Logger.initializeLogger()
        do {
            try AppDatabase.shared.connect(dbName: dbName)
        } catch {

        }
        AppAPI.configure(baseURL: apiUrl, token: apiToken)
        _ = ApiManagerCache.shared
    }

    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(themeManager)
                .environmentObject(AppDatabase.shared)
        }
    }
}
