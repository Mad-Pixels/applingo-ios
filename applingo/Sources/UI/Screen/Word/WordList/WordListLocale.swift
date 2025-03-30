import Foundation

final class WordListLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.wordList.title"
        case search = "base.text.search"
        case noWords = "base.text.noItems"
        case downloadDictionary = "screen.wordList.button.downloadDictionary"
        case importDictionary = "screen.wordList.button.importDictionary"
        case downloadDictionaryDescription = "screen.wordList.button.downloadDictionaryDescription"
        case importDictionaryDescription = "screen.wordList.button.importDictionaryDescription"
    }
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    @Published private(set) var screenButtonDownloadDictionary: String
    @Published private(set) var screenButtonImportDictionary: String
    @Published private(set) var screenButtonDownloadDictionaryDescription: String
    @Published private(set) var screenButtonImportDictionaryDescription: String
    
    init() {
        self.screenTitle = ""
        self.screenSearch = ""
        self.screenNoWords = ""
        self.screenButtonDownloadDictionary = ""
        self.screenButtonImportDictionary = ""
        self.screenButtonDownloadDictionaryDescription = ""
        self.screenButtonImportDictionaryDescription = ""
        
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
        screenSearch = Self.localizedString(for: .search)
        screenNoWords = Self.localizedString(for: .noWords)
        screenButtonDownloadDictionary = Self.localizedString(for: .downloadDictionary)
        screenButtonImportDictionary = Self.localizedString(for: .importDictionary)
        screenButtonDownloadDictionaryDescription = Self.localizedString(for: .downloadDictionaryDescription)
        screenButtonImportDictionaryDescription = Self.localizedString(for: .importDictionaryDescription)
    }
}
