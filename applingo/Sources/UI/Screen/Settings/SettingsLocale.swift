import Foundation

final class SettingsLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.settings.title"
        case subtitleTheme = "screen.settings.subtitle.theme"
        case subtitleThemeDark = "screen.settings.subtitle.theme.dark"
        case subtitleThemeLight = "screen.settings.subtitle.theme.light"
        case subtitleLanguage = "screen.settings.subtitle.language"
        case subtitleFeedback = "screen.settings.subtitle.feedback"
        case descriptionFeedback = "screen.settings.description.feedback"
    }

    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleTheme: String
    @Published private(set) var screenSubtitleThemeDark: String
    @Published private(set) var screenSubtitleThemeLight: String
    @Published private(set) var screenSubtitleLanguage: String
    @Published private(set) var screenSubtitleFeedback: String
    @Published private(set) var screenDescriptionFeedback: String

    init() {
        self.screenTitle = ""
        self.screenSubtitleTheme = ""
        self.screenSubtitleThemeDark = ""
        self.screenSubtitleThemeLight = ""
        self.screenSubtitleLanguage = ""
        self.screenSubtitleFeedback = ""
        self.screenDescriptionFeedback = ""

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
    }
}
