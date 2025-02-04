import Foundation

/// Provides localized strings for the Settings view.
final class SettingsLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.settings.title"
        static let subtitleTheme = "screen.settings.subtitle.theme"
        static let subtitleLanguage = "screen.settings.subtitle.language"
        static let subtitleFeedback = "screen.settings.subtitle.feedback"
        static let descriptionFeedback = "screen.settings.description.feedback"
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
    
    private enum LocalizedKey {
        case title
        case subtitleTheme
        case subtitleLanguage
        case subtitleFeedback
        case descriptionFeedback
        
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleTheme: return Strings.subtitleTheme
            case .subtitleLanguage: return Strings.subtitleLanguage
            case .subtitleFeedback: return Strings.subtitleFeedback
            case .descriptionFeedback: return Strings.descriptionFeedback
            }
        }
        
        var capitalized: Bool { true }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
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
