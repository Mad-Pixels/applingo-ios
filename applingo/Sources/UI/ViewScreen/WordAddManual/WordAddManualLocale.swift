import Foundation

final class WordAddManualLocale: ObservableObject {
    private enum Strings {
        static let addWord = "AddWord"
        static let card = "Card"
        static let word = "Word"
        static let definition = "Definition"
        static let additional = "Additional"
        static let hint = "Hint"
        static let description = "Description"
        static let save = "Save"
        static let cancel = "Cancel"
        static let error = "Error"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var cardTitle: String
    @Published private(set) var wordPlaceholder: String
    @Published private(set) var definitionPlaceholder: String
    @Published private(set) var additionalTitle: String
    @Published private(set) var hintPlaceholder: String
    @Published private(set) var descriptionPlaceholder: String
    @Published private(set) var saveTitle: String
    @Published private(set) var cancelTitle: String
    @Published private(set) var errorTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.cardTitle = Self.localizedString(for: .cardTitle)
        self.wordPlaceholder = Self.localizedString(for: .wordPlaceholder)
        self.definitionPlaceholder = Self.localizedString(for: .definitionPlaceholder)
        self.additionalTitle = Self.localizedString(for: .additionalTitle)
        self.hintPlaceholder = Self.localizedString(for: .hintPlaceholder)
        self.descriptionPlaceholder = Self.localizedString(for: .descriptionPlaceholder)
        self.saveTitle = Self.localizedString(for: .saveTitle)
        self.cancelTitle = Self.localizedString(for: .cancelTitle)
        self.errorTitle = Self.localizedString(for: .errorTitle)
        
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
    
    private enum LocalizedKey {
        case navigationTitle
        case cardTitle
        case wordPlaceholder
        case definitionPlaceholder
        case additionalTitle
        case hintPlaceholder
        case descriptionPlaceholder
        case saveTitle
        case cancelTitle
        case errorTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.addWord
            case .cardTitle: return Strings.card
            case .wordPlaceholder: return Strings.word
            case .definitionPlaceholder: return Strings.definition
            case .additionalTitle: return Strings.additional
            case .hintPlaceholder: return Strings.hint
            case .descriptionPlaceholder: return Strings.description
            case .saveTitle: return Strings.save
            case .cancelTitle: return Strings.cancel
            case .errorTitle: return Strings.error
            }
        }
        
        var capitalized: Bool {
            return true
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
        cardTitle = Self.localizedString(for: .cardTitle)
        wordPlaceholder = Self.localizedString(for: .wordPlaceholder)
        definitionPlaceholder = Self.localizedString(for: .definitionPlaceholder)
        additionalTitle = Self.localizedString(for: .additionalTitle)
        hintPlaceholder = Self.localizedString(for: .hintPlaceholder)
        descriptionPlaceholder = Self.localizedString(for: .descriptionPlaceholder)
        saveTitle = Self.localizedString(for: .saveTitle)
        cancelTitle = Self.localizedString(for: .cancelTitle)
        errorTitle = Self.localizedString(for: .errorTitle)
    }
}
