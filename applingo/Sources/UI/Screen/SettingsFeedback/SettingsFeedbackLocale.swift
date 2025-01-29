import Foundation

final class SettingsFeedbackLocale: ObservableObject {
    private enum Strings {
        static let quiz = "Quiz"
        static let matchHunt = "MatchHunt"
        static let verifyIt = "VerifyIt"
        static let settings = "Settings"
        static let theme = "Theme"
        static let language = "Language"
        static let logSettings = "Log Settings"
        static let sendErrorLogs = "Send Error Logs"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var themeTitle: String
    @Published private(set) var languageTitle: String
    @Published private(set) var logSettingsTitle: String
    @Published private(set) var sendErrorLogsTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .settings)
        self.themeTitle = Self.localizedString(for: .theme)
        self.languageTitle = Self.localizedString(for: .language)
        self.logSettingsTitle = Self.localizedString(for: .logSettings)
        self.sendErrorLogsTitle = Self.localizedString(for: .sendErrorLogs)
        
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
        case settings
        case theme
        case language
        case logSettings
        case sendErrorLogs
        
        var key: String {
            switch self {
            case .settings: return Strings.settings
            case .theme: return Strings.theme
            case .language: return Strings.language
            case .logSettings: return Strings.logSettings
            case .sendErrorLogs: return Strings.sendErrorLogs
            }
        }
        
        var capitalized: Bool {
            true
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .settings)
        themeTitle = Self.localizedString(for: .theme)
        languageTitle = Self.localizedString(for: .language)
        logSettingsTitle = Self.localizedString(for: .logSettings)
        sendErrorLogsTitle = Self.localizedString(for: .sendErrorLogs)
    }
}
