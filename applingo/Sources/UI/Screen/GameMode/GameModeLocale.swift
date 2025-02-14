import Foundation

/// Provides localized strings for the GameMode view.
final class GameModeLocale: ObservableObject {
    
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.gameMode.title"
        case subtitlePractice = "screen.gameMode.subtitle.practice"
        case subtitleSurvival = "screen.gameMode.subtitle.survival"
        case subtitleTime = "screen.gameMode.subtitle.time"
        case descriptionPractice = "screen.gameMode.description.practice"
        case descriptionSurvival = "screen.gameMode.description.survival"
        case descriptionTime = "screen.gameMode.description.time"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitlePractice: String
    @Published private(set) var screenSubtitleSurvival: String
    @Published private(set) var screenSubtitleTime: String
    @Published private(set) var screenDescriptionPractice: String
    @Published private(set) var screenDescriptionSurvival: String
    @Published private(set) var screenDescriptionTime: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitlePractice = Self.localizedString(for: .subtitlePractice)
        self.screenSubtitleSurvival = Self.localizedString(for: .subtitleSurvival)
        self.screenSubtitleTime = Self.localizedString(for: .subtitleTime)
        self.screenDescriptionPractice = Self.localizedString(for: .descriptionPractice)
        self.screenDescriptionSurvival = Self.localizedString(for: .descriptionSurvival)
        self.screenDescriptionTime = Self.localizedString(for: .descriptionTime)
        
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
        screenSubtitlePractice = Self.localizedString(for: .subtitlePractice)
        screenSubtitleSurvival = Self.localizedString(for: .subtitleSurvival)
        screenSubtitleTime = Self.localizedString(for: .subtitleTime)
        screenDescriptionPractice = Self.localizedString(for: .descriptionPractice)
        screenDescriptionSurvival = Self.localizedString(for: .descriptionSurvival)
        screenDescriptionTime = Self.localizedString(for: .descriptionTime)
    }
}
