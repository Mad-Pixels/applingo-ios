import Foundation

final class DictionaryRemoteDetailsLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionaryRemoteDetails.title"
        case subtitleDictionary = "screen.dictionaryRemoteDetails.subtitle.dictionary"
        case subtitleCategory = "screen.dictionaryRemoteDetails.subtitle.category"
        case subtitleAdditional = "screen.dictionaryRemoteDetails.subtitle.additional"
        case subtitleDictionaryExist = "screen.dictionaryRemoteDetails.subtitle.dictionaryExist"
        case buttonDownload = "base.button.download"
    }
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleDictionary: String
    @Published private(set) var screenSubtitleCategory: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenButtonDownload: String
    @Published private(set) var screenSubtitleDictionaryExist: String
    
    init() {
        self.screenTitle = ""
        self.screenSubtitleDictionary = ""
        self.screenSubtitleCategory = ""
        self.screenSubtitleAdditional = ""
        self.screenButtonDownload = ""
        self.screenSubtitleDictionaryExist = ""
        
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
        screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenButtonDownload = Self.localizedString(for: .buttonDownload)
        screenSubtitleDictionaryExist = Self.localizedString(for: .subtitleDictionaryExist)
    }
}
