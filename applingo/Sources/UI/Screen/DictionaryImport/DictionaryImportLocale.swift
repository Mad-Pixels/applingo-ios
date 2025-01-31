import SwiftUI

/// Provides localized strings for the Dictionary Import view.
final class DictionaryImportLocale: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published private(set) var navigationTitle: String
    @Published private(set) var importCSVTitle: String
    @Published private(set) var titleHeader: String
    @Published private(set) var titleBody: String
    @Published private(set) var tableHeader: String
    @Published private(set) var tableColumnA: String
    @Published private(set) var tableColumnB: String
    @Published private(set) var tableColumnC: String
    @Published private(set) var tableColumnD: String
    @Published private(set) var tableBody: String
    
    // MARK: - Private Strings
    
    private enum Strings {
        static let navigationTitle = "ImportNoteTitle"
        static let importCSV = "ImportCSV"
        static let titleHeader = "DictionaryImportViewTitleHeader"
        static let titleBody = "DictionaryImportViewTitleBody"
        static let tableHeader = "DictionaryImportViewTableHeader"
        static let tableColumnA = "DictionaryImportViewTableColumnA"
        static let tableColumnB = "DictionaryImportViewTableColumnB"
        static let tableColumnC = "DictionaryImportViewTableColumnC"
        static let tableColumnD = "DictionaryImportViewTableColumnD"
        static let tableBody = "DictionaryImportViewTableBody"
    }
    
    // MARK: - Initialization
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.importCSVTitle = Self.localizedString(for: .importCSV)
        self.titleHeader = Self.localizedString(for: .titleHeader)
        self.titleBody = Self.localizedString(for: .titleBody)
        self.tableHeader = Self.localizedString(for: .tableHeader)
        self.tableColumnA = Self.localizedString(for: .tableColumnA)
        self.tableColumnB = Self.localizedString(for: .tableColumnB)
        self.tableColumnC = Self.localizedString(for: .tableColumnC)
        self.tableColumnD = Self.localizedString(for: .tableColumnD)
        self.tableBody = Self.localizedString(for: .tableBody)
        
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
        case navigationTitle, importCSV
        case titleHeader, titleBody
        case tableHeader, tableColumnA, tableColumnB, tableColumnC, tableColumnD, tableBody
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.navigationTitle
            case .importCSV: return Strings.importCSV
            case .titleHeader: return Strings.titleHeader
            case .titleBody: return Strings.titleBody
            case .tableHeader: return Strings.tableHeader
            case .tableColumnA: return Strings.tableColumnA
            case .tableColumnB: return Strings.tableColumnB
            case .tableColumnC: return Strings.tableColumnC
            case .tableColumnD: return Strings.tableColumnD
            case .tableBody: return Strings.tableBody
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle, .importCSV:
                return true
            default:
                return false
            }
        }
    }
    
    /// Retrieves a localized string for the given key.
    /// - Parameter key: The localization key.
    /// - Returns: A localized string.
    private static func localizedString(for key: LocalizedKey) -> String {
        let string = LocaleManager.shared.localizedString(for: key.key)
        return key.capitalized ? string.capitalizedFirstLetter : string
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        navigationTitle = Self.localizedString(for: .navigationTitle)
        importCSVTitle = Self.localizedString(for: .importCSV)
        titleHeader = Self.localizedString(for: .titleHeader)
        titleBody = Self.localizedString(for: .titleBody)
        tableHeader = Self.localizedString(for: .tableHeader)
        tableColumnA = Self.localizedString(for: .tableColumnA)
        tableColumnB = Self.localizedString(for: .tableColumnB)
        tableColumnC = Self.localizedString(for: .tableColumnC)
        tableColumnD = Self.localizedString(for: .tableColumnD)
        tableBody = Self.localizedString(for: .tableBody)
    }
}
