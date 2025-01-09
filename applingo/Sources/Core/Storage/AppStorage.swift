import Foundation

final class AppStorage {
    static let shared = AppStorage()
    
    private let permanent: AbstractStorage
    private let temporary: AbstractStorage
    
    private init(
        permanent: AbstractStorage = UserDefaultsStorage(),
        temporary: AbstractStorage = MemoryStorage()
    ) {
        self.permanent = permanent
        self.temporary = temporary
    }
    
    var appLocale: LocaleType {
        get {
            let storedLocale = permanent.getValue(for: "locale")
            if storedLocale.isEmpty {
                if #available(iOS 16.0, *) {
                    let systemLocale = Locale.current.language.languageCode?.identifier ?? "en"
                    return LocaleType.fromString(systemLocale)
                } else {
                    let systemLocale = Locale.current.languageCode ?? "en"
                    return LocaleType.fromString(systemLocale)
                }
            }
            return LocaleType.fromString(storedLocale)
        }
        set {
            permanent.setValue(newValue.asString, for: "locale")
        }
    }
    
    var appTheme: ThemeType {
        get { ThemeType.fromString(permanent.getValue(for: "theme")) }
        set { permanent.setValue(newValue.asString, for: "theme") }
    }
    
    var appId: String {
        get {
            let id = permanent.getValue(for: "id")
            if id.isEmpty {
                let newId = UUID().uuidString
                permanent.setValue(newId, for: "id")
                return newId
            }
            return id
        }
    }
    
    var sendLogs: Bool {
        get { permanent.getValue(for: "sendLogs") == "true" }
        set { permanent.setValue(String(newValue), for: "sendLogs") }
    }
    
    var activeScreen: ScreenType {
        get { ScreenType(rawValue: temporary.getValue(for: "screen")) ?? .game }
        set { temporary.setValue(newValue.rawValue, for: "screen") }
    }
    
    func isScreenActive(_ screen: ScreenType) -> Bool {
        return activeScreen == screen
    }
}
