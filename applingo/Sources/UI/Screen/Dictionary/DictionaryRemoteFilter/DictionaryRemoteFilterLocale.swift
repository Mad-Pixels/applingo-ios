import Foundation

final class DictionaryRemoteFilterLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionaryRemoteFilter.title"
        case subtitleSortBy = "screen.dictionaryRemoteFilter.subtitle.sortBy"
        case subtitleLanguage = "screen.dictionaryRemoteFilter.subtitle.language"
        case subtitleLevel = "screen.dictionaryRemoteFilter.subtitle.level"
        case textUFOLevel = "screen.dictionaryRemoteFilter.text.UFOLevel"
        case textBeginnerLevel = "screen.dictionaryRemoteFilter.text.beginnerLevel"
        case textElementaryLevel = "screen.dictionaryRemoteFilter.text.elementaryLevel"
        case textIntermediateLevel = "screen.dictionaryRemoteFilter.text.intermediateLevel"
        case textUpperIntermediateLevel = "screen.dictionaryRemoteFilter.text.upperIntermediateLevel"
        case textAdvancedLevel = "screen.dictionaryRemoteFilter.text.advancedLevel"
        case textProficientLevel = "screen.dictionaryRemoteFilter.text.proficientLevel"
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
    @Published private(set) var screenTextBeginnerLevel: String
    @Published private(set) var screenTextElementaryLevel: String
    @Published private(set) var screenTextIntermediateLevel: String
    @Published private(set) var screenTextUpperIntermediateLevel: String
    @Published private(set) var screenTextAdvancedLevel: String
    @Published private(set) var screenTextProficientLevel: String
    
    init() {
        self.screenTitle = ""
        self.screenSubtitleSortBy = ""
        self.screenSubtitleLanguage = ""
        self.screenSubtitleLevel = ""
        self.screenButtonSave = ""
        self.screenButtonReset = ""
        self.screenButtonClose = ""
        self.screenTextUFOLevel = ""
        self.screenTextBeginnerLevel = ""
        self.screenTextElementaryLevel = ""
        self.screenTextIntermediateLevel = ""
        self.screenTextUpperIntermediateLevel = ""
        self.screenTextAdvancedLevel = ""
        self.screenTextProficientLevel = ""
        
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
    
    func localizedCategoryName(for code: String) -> String {
        LocaleManager.shared.localizedLanguageName(for: code)
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
        screenTextBeginnerLevel = Self.localizedString(for: .textBeginnerLevel)
        screenTextElementaryLevel = Self.localizedString(for: .textElementaryLevel)
        screenTextIntermediateLevel = Self.localizedString(for: .textIntermediateLevel)
        screenTextUpperIntermediateLevel = Self.localizedString(for: .textUpperIntermediateLevel)
        screenTextAdvancedLevel = Self.localizedString(for: .textAdvancedLevel)
        screenTextProficientLevel = Self.localizedString(for: .textProficientLevel)
    }
}
