import Foundation

final class SettingsFeedbackLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.settingsFeedback.title"
        case subtitleSendLogs = "screen.settingsFeedback.subtitle.sendLogs"
        case subtitleUrls = "screen.settingsFeedback.subtitle.urls"
        case buttonAbout = "screen.settingsFeedback.button.about"
        case buttonReport = "screen.settingsFeedback.button.report"
        case descriptionSendLogs = "screen.settingsFeedback.description.sendLogs"
        case textSendLogs = "screen.settingsFeedback.text.sendLogs"
    }

    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleUrls: String
    @Published private(set) var screenButtonAbout: String
    @Published private(set) var screenButtonReport: String
    @Published private(set) var screenSubtitleSendLogs: String
    @Published private(set) var screenDescriptionSendLogs: String
    @Published private(set) var screenTextSendLogs: String

    init() {
        self.screenTitle = ""
        self.screenSubtitleUrls = ""
        self.screenButtonAbout = ""
        self.screenButtonReport = ""
        self.screenSubtitleSendLogs = ""
        self.screenDescriptionSendLogs = ""
        self.screenTextSendLogs = ""

        updateLocalizedStrings()

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

    @objc private func localeDidChange() {
        updateLocalizedStrings()
    }

    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.rawValue)
    }

    private func updateLocalizedStrings() {
        screenTitle = Self.localizedString(for: .title)
        screenSubtitleUrls = Self.localizedString(for: .subtitleUrls)
        screenButtonAbout = Self.localizedString(for: .buttonAbout)
        screenButtonReport = Self.localizedString(for: .buttonReport)
        screenSubtitleSendLogs = Self.localizedString(for: .subtitleSendLogs)
        screenDescriptionSendLogs = Self.localizedString(for: .descriptionSendLogs)
        screenTextSendLogs = Self.localizedString(for: .textSendLogs)
    }
}
