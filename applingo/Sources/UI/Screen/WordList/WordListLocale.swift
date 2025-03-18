import Foundation

/// Provides localized strings for the WordList view.
final class WordListLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.wordList.title"
        case search = "base.text.search"
        case noWords = "base.text.noItems"
        case downloadDictionary = "screen.wordList.button.downloadDictionary"
        case importDictionary = "screen.wordList.button.importDictionary"
        case downloadDictionaryDescription = "screen.wordList.button.downloadDictionaryDescription"
        case importDictionaryDescription = "screen.wordList.button.importDictionaryDescription"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    @Published private(set) var screenButtonDownloadDictionary: String
    @Published private(set) var screenButtonImportDictionary: String
    @Published private(set) var screenButtonDownloadDictionaryDescription: String
    @Published private(set) var screenButtonImportDictionaryDescription: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSearch = Self.localizedString(for: .search)
        self.screenNoWords = Self.localizedString(for: .noWords)
        self.screenButtonDownloadDictionary = Self.localizedString(for: .downloadDictionary)
        self.screenButtonImportDictionary = Self.localizedString(for: .importDictionary)
        self.screenButtonDownloadDictionaryDescription = Self.localizedString(for: .downloadDictionaryDescription)
        self.screenButtonImportDictionaryDescription = Self.localizedString(for: .importDictionaryDescription)
        
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
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSearch = Self.localizedString(for: .search)
        self.screenNoWords = Self.localizedString(for: .noWords)
        self.screenButtonDownloadDictionary = Self.localizedString(for: .downloadDictionary)
        self.screenButtonImportDictionary = Self.localizedString(for: .importDictionary)
        self.screenButtonDownloadDictionaryDescription = Self.localizedString(for: .downloadDictionaryDescription)
        self.screenButtonImportDictionaryDescription = Self.localizedString(for: .importDictionaryDescription)
    }
}
