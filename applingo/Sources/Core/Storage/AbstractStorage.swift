import Foundation

protocol AbstractStorage {
    // App Settings
    var appLanguage: String? { get set }
    var appTheme: String? { get set }
    var appId: String { get }
    
    var sendLogs: Bool { get set }
}
