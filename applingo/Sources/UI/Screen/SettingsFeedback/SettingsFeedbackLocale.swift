import Foundation

/// Provides localized strings for the SettingsFeedback view.
final class SettingsFeedbackLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.settingsFeedback.title"
        case subtitleSendLogs = "screen.settingsFeedback.subtitle.sendLogs"
        case subtitleUrls = "screen.settingsFeedback.subtitle.urls"
        case buttonAbout = "screen.settingsFeedback.button.about"
        case buttonReport = "screen.settingsFeedback.button.report"
        case descriptionSendLogs = "screen.settingsFeedback.description.sendLogs"
        case textSendLogs = "screen.settingsFeedback.text.sendLogs"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleUrls: String
    @Published private(set) var screenButtonAbout: String
    @Published private(set) var screenButtonReport: String
    @Published private(set) var screenSubtitleSendLogs: String
    @Published private(set) var screenDescriptionSendLogs: String
    @Published private(set) var screenTextSendLogs: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleUrls = Self.localizedString(for: .subtitleUrls)
        self.screenButtonAbout = Self.localizedString(for: .buttonAbout)
        self.screenButtonReport = Self.localizedString(for: .buttonReport)
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
    /// Returns a localized string for the specified key.
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }
    
    // MARK: - Notification Handler
    @objc private func localeDidChange() {
        screenTitle = Self.localizedString(for: .title)
        screenSubtitleUrls = Self.localizedString(for: .subtitleUrls)
        screenButtonAbout = Self.localizedString(for: .buttonAbout)
        screenButtonReport = Self.localizedString(for: .buttonReport)
        screenSubtitleSendLogs = Self.localizedString(for: .subtitleSendLogs)
        screenDescriptionSendLogs = Self.localizedString(for: .descriptionSendLogs)
        screenTextSendLogs = Self.localizedString(for: .textSendLogs)
    }
}
