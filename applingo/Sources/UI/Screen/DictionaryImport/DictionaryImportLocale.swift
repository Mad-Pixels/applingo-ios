import SwiftUI

/// Provides localized strings for the Dictionary Import view.
final class DictionaryImportLocale: ObservableObject {
    
    // MARK: - Private Constants
    
    private enum Strings {
        static let title = "screen.dictionaryImport.title"
        static let textNote = "screen.dictionaryImport.text.note"
        static let tagRequired = "screen.dictionaryImport.tag.required"
        static let tagOptional = "screen.dictionaryImport.tag.optional"
        static let descriptionBlockA = "screen.dictionaryImport.description.BlockA"
        static let descriptionBlockB = "screen.dictionaryImport.description.BlockB"
        static let descriptionBlockC = "screen.dictionaryImport.description.BlockC"
        static let descriptionBlockD = "screen.dictionaryImport.description.BlockD"
        static let subtitleCreateTable = "screen.dictionaryImport.subtitle.ctreateTable"
        static let subtitleDictionaryAdd = "screen.dictionaryImport.subtitle.dictionaryAdd"
        
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
    
    // MARK: - Published Properties
    
    @Published private(set) var screenTitle: String
    @Published private(set) var screenTextNote: String
    @Published private(set) var screenTagRequired: String
    @Published private(set) var screenTagOptional: String
    @Published private(set) var screenDescriptionBlockA: String
    @Published private(set) var screenDescriptionBlockB: String
    @Published private(set) var screenDescriptionBlockC: String
    @Published private(set) var screenDescriptionBlockD: String
    @Published private(set) var screenSubtitleCreateTable: String
    @Published private(set) var screenSubtitleDictionaryAdd: String
    
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
    
    
    
    // MARK: - Initialization
    
    init() {
        self.screenTitle = Self.localizedString(for: .title)
        self.screenTextNote = Self.localizedString(for: .textNote)
        self.screenTagRequired = Self.localizedString(for: .tagRequired)
        self.screenTagOptional = Self.localizedString(for: .tagOptional)
        self.screenDescriptionBlockA = Self.localizedString(for: .descriptionBlockA)
        self.screenDescriptionBlockB = Self.localizedString(for: .descriptionBlockB)
        self.screenDescriptionBlockC = Self.localizedString(for: .descriptionBlockC)
        self.screenDescriptionBlockD = Self.localizedString(for: .descriptionBlockD)
        self.screenSubtitleCreateTable = Self.localizedString(for: .subtitleCreateTable)
        self.screenSubtitleDictionaryAdd = Self.localizedString(for: .subtitleDictionaryAdd)
        
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
        case title
        case textNote
        case tagRequired
        case tagOptional
        case descriptionBlockA
        case descriptionBlockB
        case descriptionBlockC
        case descriptionBlockD
        case subtitleCreateTable
        case subtitleDictionaryAdd
        
        case navigationTitle, importCSV
        case titleHeader, titleBody
        case tableHeader, tableColumnA, tableColumnB, tableColumnC, tableColumnD, tableBody
        
        var key: String {
            switch self {
            case .title: return Strings.title
            case .textNote: return Strings.textNote
            case .tagRequired: return Strings.tagRequired
            case .tagOptional: return Strings.tagOptional
            case .descriptionBlockA: return Strings.descriptionBlockA
            case .descriptionBlockB: return Strings.descriptionBlockB
            case .descriptionBlockC: return Strings.descriptionBlockC
            case .descriptionBlockD: return Strings.descriptionBlockD
            case .subtitleCreateTable: return Strings.subtitleCreateTable
            case .subtitleDictionaryAdd: return Strings.subtitleDictionaryAdd
                
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
    }
    
    private static func localizedString(for key: LocalizedKey) -> String {
        return LocaleManager.shared.localizedString(for: key.key)
    }
    
    // MARK: - Notification Handler
    
    @objc private func localeDidChange() {
        screenTitle = Self.localizedString(for: .title)
        screenTextNote = Self.localizedString(for: .textNote)
        screenTagRequired = Self.localizedString(for: .tagRequired)
        screenTagOptional = Self.localizedString(for: .tagOptional)
        screenDescriptionBlockA = Self.localizedString(for: .descriptionBlockA)
        screenDescriptionBlockB = Self.localizedString(for: .descriptionBlockB)
        screenDescriptionBlockC = Self.localizedString(for: .descriptionBlockC)
        screenDescriptionBlockD = Self.localizedString(for: .descriptionBlockD)
        screenSubtitleCreateTable = Self.localizedString(for: .subtitleCreateTable)
        screenSubtitleDictionaryAdd = Self.localizedString(for: .subtitleDictionaryAdd)
        
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
