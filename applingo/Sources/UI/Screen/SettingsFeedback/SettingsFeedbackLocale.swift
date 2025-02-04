import Foundation

/// Provides localized strings for the SettingsFeedback view.
final class SettingsFeedbackLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.settingsFeedback.title"
        static let subtitleSendLogs = "screen.settingsFeedback.subtitle.sendLogs"
        static let descriptionSendLogs = "screen.settingsFeedback.description.sendLogs"
        static let textSendLogs = "screen.settingsFeedback.text.sendLogs"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleSendLogs: String
    @Published private(set) var screenDescriptionSendLogs: String
    @Published private(set) var screenTextSendLogs: String
    
    // MARK: - Initialization
    
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleSendLogs = Self.localizedString(for: .subtitleSendLogs)
        self.screenDescriptionSendLogs = Self.localizedString(for: .descriptionSendLogs)
        self.screenTextSendLogs = Self.localizedString(for: .textSendLogs)
        
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
    
    // MARK: - Localization Helper
    
    private enum LocalizedKey {
        case title
        case subtitleSendLogs
        case descriptionSendLogs
        case textSendLogs
        
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleSendLogs: return Strings.subtitleSendLogs
            case .descriptionSendLogs: return Strings.descriptionSendLogs
            case .textSendLogs: return Strings.textSendLogs
            }
        }
        
        var capitalized: Bool { true }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleSendLogs = Self.localizedString(for: .subtitleSendLogs)
        self.screenDescriptionSendLogs = Self.localizedString(for: .descriptionSendLogs)
        self.screenTextSendLogs = Self.localizedString(for: .textSendLogs)
    }
}
