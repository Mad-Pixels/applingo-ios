import Foundation

/// Provides localized strings for the WordAddManual view.
final class WordAddManualLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.wordAddManual.title"
        static let subtitleWord = "screen.wordAddManual.subtitle.word"
        static let subtitleAdditional = "screen.wordAddManual.subtitle.additional"
        static let descriptionFrontText = "screen.wordAddManual.description.frontText"
        static let descriptionBackText = "screen.wordAddManual.description.backText"
        static let descriptionHint = "screen.wordAddManual.description.hint"
        static let descriptionDescription = "screen.wordAddManual.description.description"
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
    
    private enum LocalizedKey {
        case title
        case subtitleWord
        case subtitleAdditional
        case descriptionFrontText
        case descriptionBackText
        case descriptionHint
        case descriptionDescription
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleWord: return Strings.subtitleWord
            case .subtitleAdditional: return Strings.subtitleAdditional
            case .descriptionFrontText: return Strings.descriptionFrontText
            case .descriptionBackText: return Strings.descriptionBackText
            case .descriptionHint: return Strings.descriptionHint
            case .descriptionDescription: return Strings.descriptionDescription
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
        screenDescriptionFrontText = Self.localizedString(for: .descriptionFrontText)
        screenDescriptionBackText = Self.localizedString(for: .descriptionBackText)
        screenDescriptionHint = Self.localizedString(for: .descriptionHint)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
    }
}
