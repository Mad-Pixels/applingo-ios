import Foundation

final class DictionaryListRemoteLocale: ObservableObject {
    private enum Strings {
        static let dictionaries = "Dictionaries"
        static let search = "Search"
        static let filter = "Filter"
        static let back = "Back"
        static let noWords = "NoWordsAvailable"
        static let error = "Error"
        static let close = "Close"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var searchPlaceholder: String
    @Published private(set) var filterTitle: String
    @Published private(set) var backTitle: String
    @Published private(set) var emptyMessage: String
    @Published private(set) var errorTitle: String
    @Published private(set) var closeTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.searchPlaceholder = Self.localizedString(for: .searchPlaceholder)
        self.filterTitle = Self.localizedString(for: .filterTitle)
        self.backTitle = Self.localizedString(for: .backTitle)
        self.emptyMessage = Self.localizedString(for: .emptyMessage)
        self.errorTitle = Self.localizedString(for: .errorTitle)
        self.closeTitle = Self.localizedString(for: .closeTitle)
        
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
        case navigationTitle, searchPlaceholder, filterTitle, backTitle
        case emptyMessage, errorTitle, closeTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.dictionaries
            case .searchPlaceholder: return Strings.search
            case .filterTitle: return Strings.filter
            case .backTitle: return Strings.back
            case .emptyMessage: return Strings.noWords
            case .errorTitle: return Strings.error
            case .closeTitle: return Strings.close
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle, .searchPlaceholder,
                 .filterTitle, .backTitle:
                return true
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
        filterTitle = Self.localizedString(for: .filterTitle)
        backTitle = Self.localizedString(for: .backTitle)
        emptyMessage = Self.localizedString(for: .emptyMessage)
        errorTitle = Self.localizedString(for: .errorTitle)
        closeTitle = Self.localizedString(for: .closeTitle)
    }
}
