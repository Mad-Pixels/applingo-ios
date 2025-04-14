import IQKeyboardManagerSwift
import SwiftUI

@main
struct LingocardApp: App {
    private let apiToken = GlobalConfig.apiToken
    private let apiUrl = GlobalConfig.apiURL
    private let dbName = GlobalConfig.dbFile
    
    init() {
        Logger.initializeLogger()
        
        do {
            try AppDatabase.shared.connect(dbName: dbName)
        } catch {
            fatalError("DB connection failed: \(error)")
        }
        
        AppAPI.configure(baseURL: apiUrl, token: apiToken)
        
        AppStorage.shared.evaluateCloudAvailability()
        if AppStorage.shared.useCloud {
            AppStorage.shared.syncAllCloudData()
        }
        
        _ = ApiManagerCache.shared
        _ = HardwareHaptic.shared
        _ = TTS.shared
        _ = ASR.shared
        
        // User access request.
        Task {
            await ASR.shared.requestAccessIfNeeded()
        }
    }

    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(HardwareMotion.shared)
                .environmentObject(ThemeManager.shared)
                .environmentObject(AppDatabase.shared)
        }
    }
}
