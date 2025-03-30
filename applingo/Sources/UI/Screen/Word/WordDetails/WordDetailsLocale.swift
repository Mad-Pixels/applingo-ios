import Foundation

final class WordDetailsLocale: ObservableObject {
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
        case descriptionWrongAnswers = "screen.wordDetails.description.wrongAnswers"
        case descriptionCorrectAnswers = "screen.wordDetails.description.correctAnswers"
    }

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
    @Published private(set) var screenDescriptionWrongAnswers: String
    @Published private(set) var screenDescriptionCorrectAnswers: String

    init() {
        self.screenTitle = ""
        self.screenSubtitleWord = ""
        self.screenSubtitleNoData = ""
        self.screenSubtitleAdditional = ""
        self.screenSubtitleStatistic = ""
        self.screenSubtitleStatisticCount = ""
        self.screenDescriptionFrontText = ""
        self.screenDescriptionBackText = ""
        self.screenDescriptionDictionary = ""
        self.screenDescriptionHint = ""
        self.screenDescriptionDescription = ""
        self.screenDescriptionAuthor = ""
        self.screenDescriptionCreatedAt = ""
        self.screenDescriptionWrongAnswers = ""
        self.screenDescriptionCorrectAnswers = ""

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
        screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        screenSubtitleNoData = Self.localizedString(for: .subtitleNoData)
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
        screenDescriptionWrongAnswers = Self.localizedString(for: .descriptionWrongAnswers)
        screenDescriptionCorrectAnswers = Self.localizedString(for: .descriptionCorrectAnswers)
    }
}
