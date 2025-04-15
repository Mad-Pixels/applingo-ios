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
        _ = ApiManagerCache.shared
        _ = HardwareHaptic.shared
        _ = TTS.shared
        _ = ASR.shared
        
        AnyEncodableTask.register(CreateRemoteProfile.self)
    }

    var body: some Scene {
        WindowGroup {
            Main()
                .environmentObject(HardwareMotion.shared)
                .environmentObject(ThemeManager.shared)
                .environmentObject(AppDatabase.shared)
                .task {
                    await ASR.shared.requestAccessIfNeeded()
                    await enqueueProfileCreationIfNeeded()
                }
        }
    }

    /// Enqueues profile creation task if it hasn't been created yet.
    private func enqueueProfileCreationIfNeeded() async {
        if !AppStorage.shared.remoteProfile {
            Logger.debug("[RemoteProfile] Enqueueing task")

            TaskQueue.shared.enqueue(
                CreateRemoteProfile(
                    id: UUID().uuidString,
                    appId: AppStorage.shared.appId
                )
            )
        } else {
            Logger.debug("[RemoteProfile] Already exists")
        }
    }
}
