import Foundation

final class DictionaryListLocalLocale: ObservableObject {
    private enum Strings {
        static let dictionaries = "Dictionaries"
        static let search = "Search"
        static let importCSV = "ImportCSV"
        static let download = "Download"
        static let noDictionaries = "NoDictionariesAvailable"
        static let error = "Error"
    }
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var searchPlaceholder: String
    @Published private(set) var importTitle: String
    @Published private(set) var downloadTitle: String
    @Published private(set) var emptyMessage: String
    @Published private(set) var errorTitle: String
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.searchPlaceholder = Self.localizedString(for: .searchPlaceholder)
        self.importTitle = Self.localizedString(for: .importTitle)
        self.downloadTitle = Self.localizedString(for: .downloadTitle)
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
        case importTitle
        case downloadTitle
        case emptyMessage
        case errorTitle
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.dictionaries
            case .searchPlaceholder: return Strings.search
            case .importTitle: return Strings.importCSV
            case .downloadTitle: return Strings.download
            case .emptyMessage: return Strings.noDictionaries
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
        importTitle = Self.localizedString(for: .importTitle)
        downloadTitle = Self.localizedString(for: .downloadTitle)
        emptyMessage = Self.localizedString(for: .emptyMessage)
        errorTitle = Self.localizedString(for: .errorTitle)
    }
}
