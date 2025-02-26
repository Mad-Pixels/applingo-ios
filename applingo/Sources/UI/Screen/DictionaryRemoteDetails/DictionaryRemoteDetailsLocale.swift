import Foundation

/// Provides localized strings for the Dictionary Remote Details view.
final class DictionaryRemoteDetailsLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.dictionaryRemoteDetails.title"
        case subtitleDictionary = "screen.dictionaryRemoteDetails.subtitle.dictionary"
        case subtitleCategory = "screen.dictionaryRemoteDetails.subtitle.category"
        case subtitleAdditional = "screen.dictionaryRemoteDetails.subtitle.additional"
        case subtitleDictionaryExist = "screen.dictionaryRemoteDetails.subtitle.dictionaryExist"
        case buttonDownload = "base.button.download"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleDictionary: String
    @Published private(set) var screenSubtitleCategory: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenButtonDownload: String
    @Published private(set) var screenSubtitleDictionaryExist: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        self.screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenButtonDownload = Self.localizedString(for: .buttonDownload)
        self.screenSubtitleDictionaryExist = Self.localizedString(for: .subtitleDictionaryExist)
        
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
        screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenButtonDownload = Self.localizedString(for: .buttonDownload)
        screenSubtitleDictionaryExist = Self.localizedString(for: .subtitleDictionaryExist)
    }
}
