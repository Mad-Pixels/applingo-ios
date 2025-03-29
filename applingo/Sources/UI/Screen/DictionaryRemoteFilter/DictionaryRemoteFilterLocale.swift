import Foundation

final class DictionaryRemoteFilterLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionaryRemoteFilter.title"
        case subtitleSortBy = "screen.dictionaryRemoteFilter.subtitle.sortBy"
        case subtitleLanguage = "screen.dictionaryRemoteFilter.subtitle.language"
        case subtitleLevel = "screen.dictionaryRemoteFilter.subtitle.level"
        case textUFOLevel = "screen.dictionaryRemoteFilter.text.UFOLevel"
        case buttonSave = "base.button.save"
        case buttonReset = "base.button.reset"
        case buttonClose = "base.button.close"
    }
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleSortBy: String
    @Published private(set) var screenSubtitleLanguage: String
    @Published private(set) var screenSubtitleLevel: String
    @Published private(set) var screenButtonSave: String
    @Published private(set) var screenButtonReset: String
    @Published private(set) var screenButtonClose: String
    @Published private(set) var screenTextUFOLevel: String
    
    init() {
        self.screenTitle = ""
        self.screenSubtitleSortBy = ""
        self.screenSubtitleLanguage = ""
        self.screenSubtitleLevel = ""
        self.screenButtonSave = ""
        self.screenButtonReset = ""
        self.screenButtonClose = ""
        self.screenTextUFOLevel = ""
        
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
        screenSubtitleSortBy = Self.localizedString(for: .subtitleSortBy)
        screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        screenButtonSave = Self.localizedString(for: .buttonSave)
        screenButtonReset = Self.localizedString(for: .buttonReset)
        screenButtonClose = Self.localizedString(for: .buttonClose)
        screenTextUFOLevel = Self.localizedString(for: .textUFOLevel)
    }
}
