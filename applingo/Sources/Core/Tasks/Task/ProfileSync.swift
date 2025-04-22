import Foundation

struct ProfileSync: AbstractTask, Codable, Equatable {
    var id: String
    var appId: String
    var level: Int64
    var xp: Int64
    var retryCount: Int = 0
    var nextAttemptAt: Date? = nil

    static var type: String { "sync_profile" }
    var maxRetryCount: Int { 3 }
    
    func execute() async throws {
        Logger.debug(
            "[SyncProfile] Executing task",
            metadata: [
                "id": id,
                "appId": appId,
                "level": String(level),
                "xp": String(xp)
            ]
        )
        
        let profileAction = ProfileAction()
        
        return try await withCheckedThrowingContinuation { continuation in
            profileAction.patch(id: appId, level: level, xp: xp) { result in
                switch result {
                case .success:
                    Logger.info(
                        "[SyncProfile] Profile synced successfully",
                        metadata: [
                            "level": String(level),
                            "xp": String(xp)
                        ]
                    )
                    continuation.resume()
                    
                case .failure(let error):
                    Logger.error(
                        "[SyncProfile] Failed to sync profile",
                        metadata: ["error": error.localizedDescription]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func == (lhs: ProfileSync, rhs: ProfileSync) -> Bool {
        lhs.id == rhs.id &&
        lhs.appId == rhs.appId &&
        lhs.level == rhs.level &&
        lhs.xp == rhs.xp &&
        lhs.retryCount == rhs.retryCount &&
        lhs.nextAttemptAt == rhs.nextAttemptAt
    }
}
