import SwiftUI

/// Provides localized strings for the WordDetails view.
final class WordDetailsLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.wordDetails.title"
        case subtitleWord = "screen.wordDetails.subtitle.word"
        case subtitleNoData = "screen.wordDetails.subtitle.noData"
        case subtitleAdditional = "screen.wordDetails.subtitle.additional"
        case subtitleStatistic = "screen.wordDetails.subtitle.statistic"
        case subtitleStatisticCount = "screen.wordDetails.subtitle.statistic.count"
        case descriptionFrontText = "screen.wordDetails.description.frontText"
        case descriptionBackText = "screen.wordDetails.description.backText"
        case descriptionDictionary = "screen.wordDetails.description.dictionary"
        case descriptionHint = "screen.wordDetails.description.hint"
        case descriptionDescription = "screen.wordDetails.description.description"
        case descriptionAuthor = "screen.wordDetails.description.author"
        case descriptionCreatedAt = "screen.wordDetails.description.createdAt"
        case desctiptionWrongAnswers = "screen.wordDetails.description.wrongAnswers"
        case descriptionCorrectAnswers = "screen.wordDetails.description.correctAnswers"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleWord: String
    @Published private(set) var screenSubtitleNoData: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenSubtitleStatistic: String
    @Published private(set) var screenSubtitleStatisticCount: String
    @Published private(set) var screenDescriptionFrontText: String
    @Published private(set) var screenDescriptionBackText: String
    @Published private(set) var screenDescriptionDictionary: String
    @Published private(set) var screenDescriptionHint: String
    @Published private(set) var screenDescriptionDescription: String
    @Published private(set) var screenDescriptionAuthor: String
    @Published private(set) var screenDescriptionCreatedAt: String
    @Published private(set) var screenDesctiptionWrongAnswers: String
    @Published private(set) var screenDescriptionCorrectAnswers: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        self.screenSubtitleNoData = Self.localizedString(for: .subtitleNoData)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenSubtitleStatistic = Self.localizedString(for: .subtitleStatistic)
        self.screenSubtitleStatisticCount = Self.localizedString(for: .subtitleStatisticCount)
        self.screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        self.screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        self.screenDescriptionDictionary = Self.localizedString(for: .descriptionDictionary)
        self.screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        self.screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        self.screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        self.screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
        self.screenDesctiptionWrongAnswers = Self.localizedString(for: .desctiptionWrongAnswers)
        self.screenDescriptionCorrectAnswers = Self.localizedString(for: .descriptionCorrectAnswers)
        
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
        screenSubtitleNoData = Self.localizedString(for: .subtitleNoData)
        screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenSubtitleStatistic = Self.localizedString(for: .subtitleStatistic)
        screenSubtitleStatisticCount = Self.localizedString(for: .subtitleStatisticCount)
        screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        screenDescriptionDictionary = Self.localizedString(for: .descriptionDictionary)
        screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
        screenDesctiptionWrongAnswers = Self.localizedString(for: .desctiptionWrongAnswers)
        screenDescriptionCorrectAnswers = Self.localizedString(for: .descriptionCorrectAnswers)
    }
}
