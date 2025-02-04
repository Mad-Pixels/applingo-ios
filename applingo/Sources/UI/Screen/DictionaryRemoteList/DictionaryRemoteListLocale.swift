import Foundation

/// Provides localized strings for the Dictionary Remote List view.
final class DictionaryRemoteListLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.dictionaryRemoteList.title"
        static let search = "base.text.search"
        static let noWords = "base.text.noItems"
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
    
    private enum LocalizedKey {
        case title
        case search
        case noWords
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .search: return Strings.search
            case .noWords: return Strings.noWords
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        screenTitle = Self.localizedString(for: .title)
        screenSearch = Self.localizedString(for: .search)
        screenNoWords = Self.localizedString(for: .noWords)
    }
}
