import Foundation

final class AppStorage {
    static let shared = AppStorage()
    private var storage: AbstractStorage
    
    init(storage: AbstractStorage = UserDefaultsStorage()) {
        self.storage = storage
        Logger.debug("[AppStorage]: Initialized with \(String(describing: type(of: storage)))")
    }
    
    var appLanguage: String? {
        get { storage.appLanguage }
        set { storage.appLanguage = newValue }
    }
    
    var appTheme: String? {
        get { storage.appTheme }
        set { storage.appTheme = newValue }
    }
    
    var sendLogs: Bool {
        get { storage.sendLogs }
        set { storage.sendLogs = newValue }
    }
    
    var replicaID: String {
        storage.id
    }
}
