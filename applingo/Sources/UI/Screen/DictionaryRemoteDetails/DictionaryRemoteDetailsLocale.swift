import Foundation

/// Provides localized strings for the Dictionary Remote Details view.
final class DictionaryRemoteDetailsLocale: ObservableObject {
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let title = "screen.dictionaryRemoteDetails.title"
        static let subtitleDictionary = "screen.dictionaryRemoteDetails.subtitle.dictionary"
        static let subtitleCategory = "screen.dictionaryRemoteDetails.subtitle.category"
        static let subtitleAdditional = "screen.dictionaryRemoteDetails.subtitle.additional"
        static let buttonDownload = "base.button.download"
    }
    
    // MARK: - Published Properties
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleDictionary: String
    @Published private(set) var screenSubtitleCategory: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenButtonDownload: String
    
    // MARK: - Initialization
    
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        self.screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenButtonDownload = Self.localizedString(for: .buttonDownload)
        
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
        case subtitleDictionary
        case subtitleCategory
        case subtitleAdditional
        case buttonDownload
       
        var key: String {
            switch self {
            case .title: return Strings.title
            case .subtitleDictionary: return Strings.subtitleDictionary
            case .subtitleCategory: return Strings.subtitleCategory
            case .subtitleAdditional: return Strings.subtitleAdditional
            case .buttonDownload: return Strings.buttonDownload
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        screenTitle = Self.localizedString(for: .title)
        screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        screenButtonDownload = Self.localizedString(for: .buttonDownload)
    }
}
