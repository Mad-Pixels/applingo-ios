import Foundation

final class ScreenWordsLocale: ObservableObject {
    private enum Strings {
        static let words = "Words"
        static let search = "Search"
        static let addWord = "AddWord"
        static let noWords = "NoWordsAvailable"
        static let error = "Error"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var searchPlaceholder: String
    @Published private(set) var addTitle: String
    @Published private(set) var emptyMessage: String
    @Published private(set) var errorTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.searchPlaceholder = Self.localizedString(for: .searchPlaceholder)
        self.addTitle = Self.localizedString(for: .addTitle)
        self.emptyMessage = Self.localizedString(for: .emptyMessage)
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
        case searchPlaceholder
        case addTitle
        case emptyMessage
        case errorTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.words
            case .searchPlaceholder: return Strings.search
            case .addTitle: return Strings.addWord
            case .emptyMessage: return Strings.noWords
            case .errorTitle: return Strings.error
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle, .searchPlaceholder: return true
            default: return false
            }
        }
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
        searchPlaceholder = Self.localizedString(for: .searchPlaceholder)
        addTitle = Self.localizedString(for: .addTitle)
        emptyMessage = Self.localizedString(for: .emptyMessage)
        errorTitle = Self.localizedString(for: .errorTitle)
    }
}
