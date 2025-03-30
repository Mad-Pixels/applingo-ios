import Foundation

final class DictionaryLocalDetailsLocale: ObservableObject {
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
    
    init() {
        self.screenTitle = ""
        self.screenSubtitleDictionary = ""
        self.screenSubtitleCategory = ""
        self.screenSubtitleAdditional = ""
        self.screenDescriptionName = ""
        self.screenDescriptionDescription = ""
        self.screenDescriptionCategory = ""
        self.screenDescriptionSubcategory = ""
        self.screenDescriptionAuthor = ""
        self.screenDescriptionCreatedAt = ""
        
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
        screenDescriptionName = Self.localizedString(for: .descriptionName)
        screenDescriptionDescription = Self.localizedString(for: .descriptionDescription)
        screenDescriptionCategory = Self.localizedString(for: .descriptionCategory)
        screenDescriptionSubcategory = Self.localizedString(for: .descriptionSubcategory)
        screenDescriptionAuthor = Self.localizedString(for: .descriptionAuthor)
        screenDescriptionCreatedAt = Self.localizedString(for: .descriptionCreatedAt)
    }
}
