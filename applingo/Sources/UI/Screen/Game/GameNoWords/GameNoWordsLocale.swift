import Foundation

final class GameNoWordsLocale: ObservableObject {
    private enum LocalizedKey: String {
        case subtitle = "screen.noWords.subtitle"
        case closeButton = "base.button.close"
        case noWordsDescription = "screen.noWords.noWordsDescription"
        case addDictionariesTitle = "screen.noWords.addDictionariesTitle"
        case tabWordsDescription = "screen.noWords.tabWordsDescription"
        case tabWordsDescriptionActions = "screen.noWords.tabWordsDescriptionActions"
        case importOptionRemote = "screen.noWords.importOptionRemote"
        case importOptionLocal = "screen.noWords.importOptionLocal"
        case addDictionariesChoice = "screen.noWords.addDictionariesChoice"
        case tabDictionariesDescriptionImport = "screen.noWords.tabDictionariesDescriptionImport"
    }
    
    @Published private(set) var screenSubtitleNoWords: String
    @Published private(set) var screenButtonClose: String
    @Published private(set) var screenNoWordsDescription: String
    @Published private(set) var screenAddDictionariesTitle: String
    @Published private(set) var screenTabWordsDescription: String
    @Published private(set) var tabWordsDescriptionActions: String
    @Published private(set) var screenAddDictionariesChoice: String
    @Published private(set) var screenTabDictionariesDescriptionImport: String
    @Published private(set) var screenImportOptionRemote: String
    @Published private(set) var screenImportOptionLocal: String
    
    init() {
        self.screenSubtitleNoWords = ""
        self.screenButtonClose = ""
        self.screenNoWordsDescription = ""
        self.screenImportOptionRemote = ""
        self.screenImportOptionLocal = ""
        self.screenAddDictionariesTitle = ""
        self.screenTabWordsDescription = ""
        self.tabWordsDescriptionActions = ""
        self.screenAddDictionariesChoice = ""
        self.screenTabDictionariesDescriptionImport = ""
        
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
        screenSubtitleNoWords = Self.localizedString(for: .subtitle)
        screenButtonClose = Self.localizedString(for: .closeButton)
        screenNoWordsDescription = Self.localizedString(for: .noWordsDescription)
        screenAddDictionariesTitle = Self.localizedString(for: .addDictionariesTitle)
        screenTabWordsDescription = Self.localizedString(for: .tabWordsDescription)
        tabWordsDescriptionActions = Self.localizedString(for: .tabWordsDescriptionActions)
        screenAddDictionariesChoice = Self.localizedString(for: .addDictionariesChoice)
        screenTabDictionariesDescriptionImport = Self.localizedString(for: .tabDictionariesDescriptionImport)
        screenImportOptionRemote = Self.localizedString(for: .importOptionRemote)
        screenImportOptionLocal = Self.localizedString(for: .importOptionLocal)
    }
}
