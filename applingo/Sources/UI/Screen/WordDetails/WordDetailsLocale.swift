import Foundation

/// Provides localized strings for the WordDetails view.
final class WordDetailsLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.wordDetails.title"
        static let subtitleWord = "screen.wordDetails.subtitle.word"
        static let subtitleAdditional = "screen.wordDetails.subtitle.additional"
        static let subtitleStatistic = "screen.wordDetails.subtitle.statistic"
        static let descriptionFrontText = "screen.wordDetails.description.frontText"
        static let descriptionBackText = "screen.wordDetails.description.backText"
        static let descriptionDictionary = "screen.wordDetails.description.dictionary"
        static let descriptionHint = "screen.wordDetails.description.hint"
        static let descriptionDescription = "screen.wordDetails.description.description"
        static let descriptionAuthor = "screen.wordDetails.description.author"
        static let descriptionCreatedAt = "screen.wordDetails.description.createdAt"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleWord: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenSubtitleStatistic: String
    @Published private(set) var screenDescriptionFrontText: String
    @Published private(set) var screenDescriptionBackText: String
    @Published private(set) var screenDescriptionDictionary: String
    @Published private(set) var screenDescriptionHint: String
    @Published private(set) var screenDescriptionDescription: String
    @Published private(set) var screenDescriptionAuthor: String
    @Published private(set) var screenDescriptionCreatedAt: String
    
    // MARK: - Initialization
    
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenSubtitleStatistic = Self.localizedString(for: .subtitleStatistic)
        self.screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        self.screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        self.screenDescriptionDictionary = Self.localizedString(for: .descriptionDictionary)
        self.screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        self.screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        self.screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        self.screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)

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
        case subtitleWord
        case subtitleAdditional
        case subtitleStatistic
        case descriptionFrontText
        case descriptionBackText
        case descriptionHint
        case descriptionDescription
        case descriptionAuthor
        case descriptionCreatedAt
        case descriptionDictionary
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleWord: return Strings.subtitleWord
            case .subtitleAdditional: return Strings.subtitleAdditional
            case .subtitleStatistic: return Strings.subtitleStatistic
            case .descriptionFrontText: return Strings.descriptionFrontText
            case .descriptionBackText: return Strings.descriptionBackText
            case .descriptionDictionary: return Strings.descriptionDictionary
            case .descriptionHint: return Strings.descriptionHint
            case .descriptionDescription: return Strings.descriptionDescription
            case .descriptionAuthor: return Strings.descriptionAuthor
            case .descriptionCreatedAt: return Strings.descriptionCreatedAt
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
        screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenSubtitleStatistic = Self.localizedString(for: .subtitleStatistic)
        screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        screenDescriptionDictionary = Self.localizedString(for: .descriptionDescription)
        screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
    }
}
