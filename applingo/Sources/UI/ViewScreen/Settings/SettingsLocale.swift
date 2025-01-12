import Foundation

final class SettingsLocale: ObservableObject {
    private enum Strings {
        static let theme = "Theme"
        static let settings = "Settings"
        static let language = "Language"
        static let logSettings = "LogSettings"
        static let sendErrorLogs = "SendErrorsLogs"
    }

    @Published private(set) var navigationTitle: String
    @Published private(set) var themeTitle: String
    @Published private(set) var languageTitle: String
    @Published private(set) var logSettingsTitle: String
    @Published private(set) var sendErrorLogsTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.themeTitle = Self.localizedString(for: .themeTitle)
        self.languageTitle = Self.localizedString(for: .languageTitle)
        self.logSettingsTitle = Self.localizedString(for: .logSettingsTitle)
        self.sendErrorLogsTitle = Self.localizedString(for: .sendErrorLogsTitle)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(localeDidChange),
            name: LocaleManager.localeDidChangeNotification,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private enum LocalizedKey {
        case navigationTitle
        case themeTitle
        case languageTitle
        case logSettingsTitle
        case sendErrorLogsTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.settings
            case .themeTitle: return Strings.theme
            case .languageTitle: return Strings.language
            case .logSettingsTitle: return Strings.logSettings
            case .sendErrorLogsTitle: return Strings.sendErrorLogs
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle: return true
            default: return false
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
        themeTitle = Self.localizedString(for: .themeTitle)
        languageTitle = Self.localizedString(for: .languageTitle)
        logSettingsTitle = Self.localizedString(for: .logSettingsTitle)
        sendErrorLogsTitle = Self.localizedString(for: .sendErrorLogsTitle)
    }
}
