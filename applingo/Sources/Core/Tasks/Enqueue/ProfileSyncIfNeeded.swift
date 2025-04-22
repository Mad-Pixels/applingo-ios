import Foundation

func enqueueProfileSync() async {
    if AppStorage.shared.remoteProfile {
        await TaskQueue.shared.enqueue(
            ProfileSync(
                id: UUID().uuidString,
                appId: AppStorage.shared.appId,
                level: ProfileStorage.shared.get().level,
                xp: ProfileStorage.shared.get().xpCurrent
            )
        )
    } else {
        Logger.debug("[enqueueProfileSyncIfNeeded] Skipping")
    }
}
