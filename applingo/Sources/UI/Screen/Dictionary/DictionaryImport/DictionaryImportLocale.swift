import Foundation

final class DictionaryImportLocale: ObservableObject {
    private enum LocalizedKey: String {
        case title = "screen.dictionaryImport.title"
        case textNote = "screen.dictionaryImport.text.note"
        case tagRequired = "screen.dictionaryImport.tag.required"
        case tagOptional = "screen.dictionaryImport.tag.optional"
        case descriptionBlockA = "screen.dictionaryImport.description.BlockA"
        case descriptionBlockB = "screen.dictionaryImport.description.BlockB"
        case descriptionBlockC = "screen.dictionaryImport.description.BlockC"
        case descriptionBlockD = "screen.dictionaryImport.description.BlockD"
        case subtitleCreateTable = "screen.dictionaryImport.subtitle.ctreateTable"
        case subtitleDictionaryAdd = "screen.dictionaryImport.subtitle.dictionaryAdd"
        case textDictionaryAdd = "screen.dictionaryImport.text.dictionaryAdd"
        case navigationTitle = "ImportNoteTitle"
        case titleHeader = "DictionaryImportViewTitleHeader"
        case titleBody = "DictionaryImportViewTitleBody"
        case tableHeader = "DictionaryImportViewTableHeader"
        case tableColumnA = "DictionaryImportViewTableColumnA"
        case tableColumnB = "DictionaryImportViewTableColumnB"
        case tableColumnC = "DictionaryImportViewTableColumnC"
        case tableColumnD = "DictionaryImportViewTableColumnD"
        case tableBody = "DictionaryImportViewTableBody"
    }

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
    @Published private(set) var screenTextDictionaryAdd: String
    @Published private(set) var navigationTitle: String
    @Published private(set) var titleHeader: String
    @Published private(set) var titleBody: String
    @Published private(set) var tableHeader: String
    @Published private(set) var tableColumnA: String
    @Published private(set) var tableColumnB: String
    @Published private(set) var tableColumnC: String
    @Published private(set) var tableColumnD: String
    @Published private(set) var tableBody: String

    init() {
        self.screenTitle = ""
        self.screenTextNote = ""
        self.screenTagRequired = ""
        self.screenTagOptional = ""
        self.screenDescriptionBlockA = ""
        self.screenDescriptionBlockB = ""
        self.screenDescriptionBlockC = ""
        self.screenDescriptionBlockD = ""
        self.screenSubtitleCreateTable = ""
        self.screenSubtitleDictionaryAdd = ""
        self.screenTextDictionaryAdd = ""
        self.navigationTitle = ""
        self.titleHeader = ""
        self.titleBody = ""
        self.tableHeader = ""
        self.tableColumnA = ""
        self.tableColumnB = ""
        self.tableColumnC = ""
        self.tableColumnD = ""
        self.tableBody = ""

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
        screenTextNote = Self.localizedString(for: .textNote)
        screenTagRequired = Self.localizedString(for: .tagRequired)
        screenTagOptional = Self.localizedString(for: .tagOptional)
        screenDescriptionBlockA = Self.localizedString(for: .descriptionBlockA)
        screenDescriptionBlockB = Self.localizedString(for: .descriptionBlockB)
        screenDescriptionBlockC = Self.localizedString(for: .descriptionBlockC)
        screenDescriptionBlockD = Self.localizedString(for: .descriptionBlockD)
        screenSubtitleCreateTable = Self.localizedString(for: .subtitleCreateTable)
        screenSubtitleDictionaryAdd = Self.localizedString(for: .subtitleDictionaryAdd)
        screenTextDictionaryAdd = Self.localizedString(for: .textDictionaryAdd)
        navigationTitle = Self.localizedString(for: .navigationTitle)
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
