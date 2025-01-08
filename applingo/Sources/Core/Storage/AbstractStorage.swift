import Foundation

protocol AbstractStorage {
    // App Settings
    var appLanguage: String? { get set }
    var appTheme: String? { get set }
    var sendLogs: Bool { get set }
    
    // App Identity
    var id: String { get }
}
