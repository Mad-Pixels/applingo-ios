import Foundation

/// Provides localized strings for the dictionary remote filter view.
/// This class manages localized UI text and updates dynamically when the locale changes.
final class DictionaryRemoteFilterLocale: ObservableObject {
    // MARK: - Localized Keys
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
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleSortBy: String
    @Published private(set) var screenSubtitleLanguage: String
    @Published private(set) var screenSubtitleLevel: String
    @Published private(set) var screenButtonSave: String
    @Published private(set) var screenButtonReset: String
    @Published private(set) var screenButtonClose: String
    @Published private(set) var screenTextUFOLevel: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleSortBy = Self.localizedString(for: .subtitleSortBy)
        self.screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        self.screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        self.screenButtonSave = Self.localizedString(for: .buttonSave)
        self.screenButtonReset = Self.localizedString(for: .buttonReset)
        self.screenButtonClose = Self.localizedString(for: .buttonClose)
        self.screenTextUFOLevel = Self.localizedString(for: .textUFOLevel)
        
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
        screenSubtitleSortBy = Self.localizedString(for: .subtitleSortBy)
        screenSubtitleLanguage = Self.localizedString(for: .subtitleLanguage)
        screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        screenButtonSave = Self.localizedString(for: .buttonSave)
        screenButtonReset = Self.localizedString(for: .buttonReset)
        screenButtonClose = Self.localizedString(for: .buttonClose)
        screenTextUFOLevel = Self.localizedString(for: .textUFOLevel)
    }
}
