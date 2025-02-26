import Foundation

/// Provides localized strings for the Dictionary Local List view.
final class DictionaryLocalListLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.dictionaryLocalList.title"
        case search = "base.text.search"
        case noWords = "base.text.noItems"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSearch = Self.localizedString(for: .search)
        self.screenNoWords = Self.localizedString(for: .noWords)
        
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
    }
}
