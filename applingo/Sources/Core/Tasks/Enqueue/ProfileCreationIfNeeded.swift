import Foundation

func enqueueProfileCreate() async {
    if !AppStorage.shared.remoteProfile {
        await TaskQueue.shared.enqueue(
            ProfileCreate(
                id: UUID().uuidString,
                appId: AppStorage.shared.appId
            )
        )
    } else {
        Logger.debug("[enqueueProfileCreationIfNeeded] Already exists")
    }
}
