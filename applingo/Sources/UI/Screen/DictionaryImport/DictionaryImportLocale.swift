import SwiftUI

final class DictionaryImportLocale: ObservableObject {
    @Published private(set) var navigationTitle: String
    @Published private(set) var columnsTitle: String
    @Published private(set) var examplesTitle: String
    @Published private(set) var importCSVTitle: String
    @Published private(set) var closeTitle: String
    @Published private(set) var warningTitle: String
    @Published private(set) var commaSeparatedTitle: String
    @Published private(set) var semicolonSeparatedTitle: String
    @Published private(set) var verticalBarSeparatedTitle: String
    @Published private(set) var tabSeparatedTitle: String
    
    private enum Strings {
        static let navigationTitle = "ImportNoteTitle"
        static let columns = "ImportNoteColumns"
        static let examples = "ImportNoteExampleTitle"
        static let importCSV = "ImportCSV"
        static let close = "Close"
        static let warning = "ImportNoteNoColumnsWarning"
        static let commaSeparated = "ImportNoteExampleCommaSeparated"
        static let semicolonsSeparated = "ImportNoteExampleSemicolonsSeparated"
        static let verticalBarSeparated = "ImportNoteExampleVerticalBarSeparated"
        static let tabSeparated = "ImportNoteExampleTabSeparated"
    }
    
    init() {
        self.navigationTitle = Self.localizedString(for: .navigationTitle)
        self.columnsTitle = Self.localizedString(for: .columns)
        self.examplesTitle = Self.localizedString(for: .examples)
        self.importCSVTitle = Self.localizedString(for: .importCSV)
        self.closeTitle = Self.localizedString(for: .close)
        self.warningTitle = Self.localizedString(for: .warning)
        self.commaSeparatedTitle = Self.localizedString(for: .commaSeparated)
        self.semicolonSeparatedTitle = Self.localizedString(for: .semicolonsSeparated)
        self.verticalBarSeparatedTitle = Self.localizedString(for: .verticalBarSeparated)
        self.tabSeparatedTitle = Self.localizedString(for: .tabSeparated)
        
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
        case navigationTitle, columns, examples, importCSV, close, warning
        case commaSeparated, semicolonsSeparated, verticalBarSeparated, tabSeparated
        
        var key: String {
            switch self {
            case .navigationTitle: return Strings.navigationTitle
            case .columns: return Strings.columns
            case .examples: return Strings.examples
            case .importCSV: return Strings.importCSV
            case .close: return Strings.close
            case .warning: return Strings.warning
            case .commaSeparated: return Strings.commaSeparated
            case .semicolonsSeparated: return Strings.semicolonsSeparated
            case .verticalBarSeparated: return Strings.verticalBarSeparated
            case .tabSeparated: return Strings.tabSeparated
            }
        }
        
        var capitalized: Bool {
            switch self {
            case .navigationTitle, .importCSV, .close: return true
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
        columnsTitle = Self.localizedString(for: .columns)
        examplesTitle = Self.localizedString(for: .examples)
        importCSVTitle = Self.localizedString(for: .importCSV)
        closeTitle = Self.localizedString(for: .close)
        warningTitle = Self.localizedString(for: .warning)
        commaSeparatedTitle = Self.localizedString(for: .commaSeparated)
        semicolonSeparatedTitle = Self.localizedString(for: .semicolonsSeparated)
        verticalBarSeparatedTitle = Self.localizedString(for: .verticalBarSeparated)
        tabSeparatedTitle = Self.localizedString(for: .tabSeparated)
    }
}
