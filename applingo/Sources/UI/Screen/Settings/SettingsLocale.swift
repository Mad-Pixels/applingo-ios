import Foundation

/// Provides localized strings for the Settings view.
final class SettingsLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.settings.title"
        case subtitleTheme = "screen.settings.subtitle.theme"
        case subtitleLanguage = "screen.settings.subtitle.language"
        case subtitleFeedback = "screen.settings.subtitle.feedback"
        case descriptionFeedback = "screen.settings.description.feedback"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleTheme: String
    @Published private(set) var screenSubtitleLanguage: String
    @Published private(set) var screenSubtitleFeedback: String
    @Published private(set) var screenDescriptionFeedback: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleTheme = Self.localizedString(for: .subtitleTheme)
        self.screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        self.screenSubtitleFeedback = Self.localizedString(for: .subtitleFeedback)
        self.screenDescriptionFeedback = Self.localizedString(for: .descriptionFeedback)
        
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
        screenSubtitleTheme = Self.localizedString(for: .subtitleTheme)
        screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        screenSubtitleFeedback = Self.localizedString(for: .subtitleFeedback)
        screenDescriptionFeedback = Self.localizedString(for: .descriptionFeedback)
    }
}
