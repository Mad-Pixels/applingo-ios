import Foundation

struct CreateRemoteProfile: AbstractTask {
    var id: String
    var appId: String
    var retryCount: Int = 0
    var nextAttemptAt: Date? = nil

    static var type: String { "create_profile" }
    var maxRetryCount: Int { 0 }

    func execute() async throws {
        Logger.debug("[CreateRemoteProfile] Simulating failure")
        
        struct SimulatedError: Error {}
        throw SimulatedError()
        
        AppStorage.shared.remoteProfile = true
    }
}
