import Foundation

final class SettingsMainLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.settings.title"
        case subtitleTheme = "screen.settings.subtitle.theme"
        case subtitleThemeDark = "screen.settings.subtitle.theme.dark"
        case subtitleThemeLight = "screen.settings.subtitle.theme.light"
        case subtitleLanguage = "screen.settings.subtitle.language"
        case subtitleFeedback = "screen.settings.subtitle.feedback"
        case descriptionFeedback = "screen.settings.description.feedback"
        case subtitleASRPermission = "screen.settings.subtitle.asrPermission"
        case descriptionASRPermission = "screen.settings.description.asrPermission"
    }

    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleTheme: String
    @Published private(set) var screenSubtitleThemeDark: String
    @Published private(set) var screenSubtitleThemeLight: String
    @Published private(set) var screenSubtitleLanguage: String
    @Published private(set) var screenSubtitleFeedback: String
    @Published private(set) var screenDescriptionFeedback: String
    @Published private(set) var screenSubtitleASRPermission: String
    @Published private(set) var screenDescriptionASRPermission: String

    init() {
        self.screenTitle = ""
        self.screenSubtitleTheme = ""
        self.screenSubtitleThemeDark = ""
        self.screenSubtitleThemeLight = ""
        self.screenSubtitleLanguage = ""
        self.screenSubtitleFeedback = ""
        self.screenDescriptionFeedback = ""
        self.screenSubtitleASRPermission = ""
        self.screenDescriptionASRPermission = ""

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
        screenSubtitleTheme = Self.localizedString(for: .subtitleTheme)
        screenSubtitleThemeDark = Self.localizedString(for: .subtitleThemeDark)
        screenSubtitleThemeLight = Self.localizedString(for: .subtitleThemeLight)
        screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        screenSubtitleFeedback = Self.localizedString(for: .subtitleFeedback)
        screenDescriptionFeedback = Self.localizedString(for: .descriptionFeedback)
        screenSubtitleASRPermission = Self.localizedString(for: .subtitleASRPermission)
        screenDescriptionASRPermission = Self.localizedString(for: .descriptionASRPermission)
    }
}
