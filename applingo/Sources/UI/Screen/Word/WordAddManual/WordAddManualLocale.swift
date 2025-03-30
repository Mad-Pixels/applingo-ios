import Foundation

final class WordAddManualLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.wordAddManual.title"
        case subtitleWord = "screen.wordAddManual.subtitle.word"
        case subtitleAdditional = "screen.wordAddManual.subtitle.additional"
        case descriptionFrontText = "screen.wordAddManual.description.frontText"
        case descriptionBackText = "screen.wordAddManual.description.backText"
        case descriptionHint = "screen.wordAddManual.description.hint"
        case descriptionDescription = "screen.wordAddManual.description.description"
    }

    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleWord: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenDescriptionFrontText: String
    @Published private(set) var screenDescriptionBackText: String
    @Published private(set) var screenDescriptionHint: String
    @Published private(set) var screenDescriptionDescription: String

    init() {
        self.screenTitle = ""
        self.screenSubtitleWord = ""
        self.screenSubtitleAdditional = ""
        self.screenDescriptionFrontText = ""
        self.screenDescriptionBackText = ""
        self.screenDescriptionHint = ""
        self.screenDescriptionDescription = ""

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
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
    }
}
