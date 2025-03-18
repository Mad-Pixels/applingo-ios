import Foundation

/// Provides localized strings for the WordList view.
final class WordListLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.wordList.title"
        case search = "base.text.search"
        case noWords = "base.text.noItems"
        case buttonDownloadDictionaty = "screen.wordList.button.downloadDictionaty"
        case buttonImportDictionaty = "screen.wordList.button.importDictionaty"
        case buttonDownloadDictionatyDescription = "screen.wordList.button.downloadDictionatyDescription"
        case buttonImportDictionatyDescription = "screen.wordList.button.importDictionatyDescription"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    @Published private(set) var screenButtonDownloadDictionaty: String
    @Published private(set) var screenButtonImportDictionaty: String
    @Published private(set) var screenButtonDownloadDictionatyDescription: String
    @Published private(set) var screenButtonImportDictionatyDescription: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSearch = Self.localizedString(for: .search)
        self.screenNoWords = Self.localizedString(for: .noWords)
        self.screenButtonDownloadDictionaty = Self.localizedString(for: .buttonDownloadDictionaty)
        self.screenButtonImportDictionaty = Self.localizedString(for: .buttonImportDictionaty)
        self.screenButtonDownloadDictionatyDescription = Self.localizedString(for: .buttonDownloadDictionatyDescription)
        self.screenButtonImportDictionatyDescription = Self.localizedString(for: .buttonImportDictionatyDescription)
        
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
        screenSearch = Self.localizedString(for: .search)
        screenNoWords = Self.localizedString(for: .noWords)
        screenButtonDownloadDictionaty = Self.localizedString(for: .buttonDownloadDictionaty)
        screenButtonImportDictionaty = Self.localizedString(for: .buttonImportDictionaty)
        screenButtonDownloadDictionatyDescription = Self.localizedString(for: .buttonDownloadDictionatyDescription)
        screenButtonImportDictionatyDescription = Self.localizedString(for: .buttonImportDictionatyDescription)
    }
}
