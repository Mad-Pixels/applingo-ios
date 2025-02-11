import Foundation

/// Provides localized strings for the WordList view.
final class WordListLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.wordList.title"
        static let search = "base.text.search"
        static let noWords = "base.text.noItems"
        static let buttonDownloadDictionaty = "screen.wordList.button.downloadDictionaty"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    @Published private(set) var screenButtonDownloadDictionaty: String
    
    // MARK: - Initialization
    
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSearch = Self.localizedString(for: .search)
        self.screenNoWords = Self.localizedString(for: .noWords)
        self.screenButtonDownloadDictionaty = Self.localizedString(for: .buttonDownloadDictionaty)
        
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
        case search
        case noWords
        case buttonDownloadDictionaty
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .search: return Strings.search
            case .noWords: return Strings.noWords
            case .buttonDownloadDictionaty: return Strings.buttonDownloadDictionaty
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
        screenSearch = Self.localizedString(for: .search)
        screenNoWords = Self.localizedString(for: .noWords)
        screenButtonDownloadDictionaty = Self.localizedString(for: .buttonDownloadDictionaty)
    }
}
