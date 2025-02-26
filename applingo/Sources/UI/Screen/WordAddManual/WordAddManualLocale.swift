import Foundation

/// Provides localized strings for the WordAddManual view.
final class WordAddManualLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.wordAddManual.title"
        case subtitleWord = "screen.wordAddManual.subtitle.word"
        case subtitleAdditional = "screen.wordAddManual.subtitle.additional"
        case descriptionFrontText = "screen.wordAddManual.description.frontText"
        case descriptionBackText = "screen.wordAddManual.description.backText"
        case descriptionHint = "screen.wordAddManual.description.hint"
        case descriptionDescription = "screen.wordAddManual.description.description"
    }

    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleWord: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenDescriptionFrontText: String
    @Published private(set) var screenDescriptionBackText: String
    @Published private(set) var screenDescriptionHint: String
    @Published private(set) var screenDescriptionDescription: String

    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        self.screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        self.screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        self.screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)

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
        screenSubtitleWord = Self.localizedString(for: .subtitleWord)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
    }
}
