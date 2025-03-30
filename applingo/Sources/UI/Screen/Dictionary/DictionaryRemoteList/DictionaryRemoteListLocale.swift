import Foundation

final class DictionaryRemoteListLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionaryRemoteList.title"
        case search = "base.text.search"
        case noWords = "base.text.noItems"
    }
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSearch: String
    @Published private(set) var screenNoWords: String
    
    init() {
        self.screenTitle = ""
        self.screenSearch = ""
        self.screenNoWords = ""
        
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
    }
}
