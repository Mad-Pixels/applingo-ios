import SwiftUI
import IQKeyboardManagerSwift

@main
struct LingocardApp: App {
    @StateObject private var hapticManager = HardwareHaptic.shared
    @StateObject private var themeManager = ThemeManager.shared
    
    private let apiUrl = GlobalConfig.apiURL
    private let apiToken = GlobalConfig.apiToken
    private let dbName = "LingocardDB.sqlite"

    init() {
        Logger.initializeLogger()
        Logger.debug("asd")
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
