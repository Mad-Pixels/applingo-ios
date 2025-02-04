import Foundation

/// Provides localized strings for the GameMode view.
final class GameModeLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.gameMode.title"
        static let subtitlePractice = "screen.gameMode.subtitle.practice"
        static let subtitleSurvival = "screen.gameMode.subtitle.survival"
        static let subtitleTime = "screen.gameMode.subtitle.time"
        static let descriptionPractice = "screen.gameMode.description.practice"
        static let descriptionSurvival = "screen.gameMode.description.survival"
        static let descriptionTime = "screen.gameMode.description.time"
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
    
    private enum LocalizedKey {
        case title
        case subtitlePractice
        case subtitleSurvival
        case subtitleTime
        case descriptionPractice
        case descriptionSurvival
        case descriptionTime
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitlePractice: return Strings.subtitlePractice
            case .subtitleSurvival: return Strings.subtitleSurvival
            case .subtitleTime: return Strings.subtitleTime
            case .descriptionPractice: return Strings.descriptionPractice
            case .descriptionSurvival: return Strings.descriptionSurvival
            case .descriptionTime: return Strings.descriptionTime
            }
        }
    }
    
    /// Returns a localized string for the specified key.
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
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
