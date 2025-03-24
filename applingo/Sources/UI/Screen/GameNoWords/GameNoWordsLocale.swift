import Foundation

/// Provides localized strings for the GameNoWords view.
final class GameNoWordsLocale: ObservableObject {
    
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case subtitle = "screen.noWords.subtitle"
        case closeButton = "base.button.close"
        case addDictionariesTitle = "screen.noWords.addDictionariesTitle"
        case tabWordsDescription = "screen.noWords.tabWordsDescription"
        case tabWordsDescriptionImport = "screen.noWords.tabWordsDescriptionImport"
        case addDictionariesChoice = "screen.noWords.addDictionariesChoice"
        case tabDictionariesDescriptionImport = "screen.noWords.tabDictionariesDescriptionImport"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenSubtitleNoWords: String
    @Published private(set) var screenButtonClose: String
    @Published private(set) var screenAddDictionariesTitle: String
    @Published private(set) var screenTabWordsDescription: String
    @Published private(set) var screenTabWordsDescriptionImport: String
    @Published private(set) var screenAddDictionariesChoice: String
    @Published private(set) var screenTabDictionariesDescriptionImport: String
    
    // MARK: - Initialization
    init() {
        self.screenSubtitleNoWords = Self.localizedString(for: .subtitle)
        self.screenButtonClose = Self.localizedString(for: .closeButton)
        self.screenAddDictionariesTitle = Self.localizedString(for: .addDictionariesTitle)
        self.screenTabWordsDescription = Self.localizedString(for: .tabWordsDescription)
        self.screenTabWordsDescriptionImport = Self.localizedString(for: .tabWordsDescriptionImport)
        self.screenAddDictionariesChoice = Self.localizedString(for: .addDictionariesChoice)
        self.screenTabDictionariesDescriptionImport = Self.localizedString(for: .tabDictionariesDescriptionImport)
        
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
        screenSubtitleNoWords = Self.localizedString(for: .subtitle)
        screenButtonClose = Self.localizedString(for: .closeButton)
        screenAddDictionariesTitle = Self.localizedString(for: .addDictionariesTitle)
        screenTabWordsDescription = Self.localizedString(for: .tabWordsDescription)
        screenTabWordsDescriptionImport = Self.localizedString(for: .tabWordsDescriptionImport)
        screenAddDictionariesChoice = Self.localizedString(for: .addDictionariesChoice)
        screenTabDictionariesDescriptionImport = Self.localizedString(for: .tabDictionariesDescriptionImport)
    }
}
