import Foundation

struct ProfileCreate: AbstractTask, Codable, Equatable {
    var id: String
    var appId: String
    var retryCount: Int = 0
    var nextAttemptAt: Date? = nil

    static var type: String { "create_profile" }
    var maxRetryCount: Int { 0 }
    
    func execute() async throws {
        Logger.debug(
            "[CreateRemoteProfile] Executing task",
            metadata: [
                "id": id,
                "appId": appId
            ]
        )
        
        let profileAction = ProfileAction()
        
        return try await withCheckedThrowingContinuation { continuation in
            profileAction.post(id: appId) { result in
                switch result {
                case .success:
                    Logger.info("[CreateRemoteProfile] Profile created successfully")
                    AppStorage.shared.remoteProfile = true
                    continuation.resume()
                    
                case .failure(let error):
                    Logger.error(
                        "[CreateRemoteProfile] Failed to create profile",
                        metadata: ["error": error.localizedDescription]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    static func == (lhs: ProfileCreate, rhs: ProfileCreate) -> Bool {
        lhs.id == rhs.id &&
        lhs.appId == rhs.appId &&
        lhs.retryCount == rhs.retryCount &&
        lhs.nextAttemptAt == rhs.nextAttemptAt
    }
}
