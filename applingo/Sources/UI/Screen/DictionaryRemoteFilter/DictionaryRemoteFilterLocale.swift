import Foundation

/// Provides localized strings for the dictionary remote filter view.
///
/// This class manages localized UI text and updates dynamically when the locale changes.
final class DictionaryRemoteFilterLocale: ObservableObject {
   
    // MARK: - Private Constants
   
    private enum Strings {
        static let title = "screen.dictionaryRemoteFilter.title"
        static let subtitleSortBy = "screen.dictionaryRemoteFilter.subtitle.sortBy"
        static let subtitleLevel = "screen.dictionaryRemoteFilter.subtitle.level"
        static let buttonSave = "base.button.save"
        static let buttonReset = "base.button.reset"
        static let buttonClose = "base.button.close"
    }
   
    // MARK: - Published Properties
   
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleSortBy: String
    @Published private(set) var screenSubtitleLevel: String
    @Published private(set) var screenButtonSave: String
    @Published private(set) var screenButtonReset: String
    @Published private(set) var screenButtonClose: String
   
    // MARK: - Initialization
   
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleSortBy = Self.localizedString(for: .subtitleSortBy)
        self.screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        self.screenButtonSave = Self.localizedString(for: .buttonSave)
        self.screenButtonReset = Self.localizedString(for: .buttonReset)
        self.screenButtonClose = Self.localizedString(for: .buttonClose)
       
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
   
    // MARK: - Private Methods
   
    private enum LocalizedKey {
        case title
        case subtitleSortBy
        case subtitleLevel
        case buttonSave
        case buttonReset
        case buttonClose
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleSortBy: return Strings.subtitleSortBy
            case .subtitleLevel: return Strings.subtitleLevel
            case .buttonSave: return Strings.buttonSave
            case .buttonReset: return Strings.buttonReset
            case .buttonClose: return Strings.buttonClose
            }
        }
    }
   
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
   
    @objc private func localeDidChange() {
        screenTitle = Self.localizedString(for: .title)
        screenSubtitleSortBy = Self.localizedString(for: .subtitleSortBy)
        screenSubtitleLevel = Self.localizedString(for: .subtitleLevel)
        screenButtonSave = Self.localizedString(for: .buttonSave)
        screenButtonReset = Self.localizedString(for: .buttonReset)
        screenButtonClose = Self.localizedString(for: .buttonClose)
    }
}
