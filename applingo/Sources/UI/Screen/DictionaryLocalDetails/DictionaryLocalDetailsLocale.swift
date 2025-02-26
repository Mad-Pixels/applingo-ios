import Foundation

/// Provides localized strings for the Dictionary Local Details view.
final class DictionaryLocalDetailsLocale: ObservableObject {
    // MARK: - Localized Keys
    private enum LocalizedKey: String {
        case title = "screen.dictionaryLocalDetails.title"
        case subtitleDictionary = "screen.dictionaryRemoteDetails.subtitle.dictionary"
        case subtitleCategory = "screen.dictionaryRemoteDetails.subtitle.category"
        case subtitleAdditional = "screen.dictionaryRemoteDetails.subtitle.additional"
        case descriptionName = "screen.dictionaryLocalDetails.description.name"
        case descriptionDescription = "screen.dictionaryLocalDetails.description.description"
        case descriptionCategory = "screen.dictionaryLocalDetails.description.category"
        case descriptionSubcategory = "screen.dictionaryLocalDetails.description.subcategory"
        case descriptionAuthor = "screen.dictionaryLocalDetails.description.author"
        case descriptionCreatedAt = "screen.dictionaryLocalDetails.description.createdAt"
    }
    
    // MARK: - Published Properties
    @Published private(set) var screenTitle: String
    @Published private(set) var screenSubtitleDictionary: String
    @Published private(set) var screenSubtitleCategory: String
    @Published private(set) var screenSubtitleAdditional: String
    @Published private(set) var screenDescriptionName: String
    @Published private(set) var screenDescriptionDescription: String
    @Published private(set) var screenDescriptionCategory: String
    @Published private(set) var screenDescriptionSubcategory: String
    @Published private(set) var screenDescriptionAuthor: String
    @Published private(set) var screenDescriptionCreatedAt: String
    
    // MARK: - Initialization
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenSubtitleDictionary = Self.localizedString(for: .subtitleDictionary)
        self.screenSubtitleCategory = Self.localizedString(for: .subtitleCategory)
        self.screenSubtitleAdditional = Self.localizedString(for: .subtitleAdditional)
        self.screenDescriptionName = Self.localizedString(for: .descriptionName)
        self.screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        self.screenDescriptionCategory = Self.localizedString(for: .descriptionCategory)
        self.screenDescriptionSubcategory = Self.localizedString(for: .descriptionSubcategory)
        self.screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        self.screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
        
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
        screenDescriptionName = Self.localizedString(for: .descriptionName)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        screenDescriptionCategory = Self.localizedString(for: .descriptionCategory)
        screenDescriptionSubcategory = Self.localizedString(for: .descriptionSubcategory)
        screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
    }
}
