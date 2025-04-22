import Foundation

protocol AbstractTask: Codable, Identifiable, Equatable {
    var id: String { get }
    static var type: String { get }

    var retryCount: Int { get set }
    var maxRetryCount: Int { get }
    var nextAttemptAt: Date? { get set }

    func execute() async throws
}
