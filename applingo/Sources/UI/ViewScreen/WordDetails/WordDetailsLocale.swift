import Foundation

final class WordDetailsLocale: ObservableObject {
   private enum Strings {
       static let details = "Details"
       static let card = "Card"
       static let word = "Word"
       static let definition = "Definition"
       static let additional = "Additional"
       static let tableName = "TableName"
       static let hint = "Hint"
       static let description = "Description"
       static let statistics = "Statistics"
       static let answers = "Answers"
       static let edit = "Edit"
       static let save = "Save"
       static let cancel = "Cancel"
       static let close = "Close"
       static let error = "Error"
   }
   
   @Published private(set) var navigationTitle: String
   @Published private(set) var cardTitle: String
   @Published private(set) var wordPlaceholder: String
   @Published private(set) var definitionPlaceholder: String
   @Published private(set) var additionalTitle: String
   @Published private(set) var tableNamePlaceholder: String
   @Published private(set) var hintPlaceholder: String
   @Published private(set) var descriptionPlaceholder: String
   @Published private(set) var statisticsTitle: String
   @Published private(set) var answersTitle: String
   @Published private(set) var editTitle: String
   @Published private(set) var saveTitle: String
   @Published private(set) var cancelTitle: String
   @Published private(set) var closeTitle: String
   @Published private(set) var errorTitle: String
   
   init() {
       self.navigationTitle = Self.localizedString(for: .navigationTitle)
       self.cardTitle = Self.localizedString(for: .cardTitle)
       self.wordPlaceholder = Self.localizedString(for: .wordPlaceholder)
       self.definitionPlaceholder = Self.localizedString(for: .definitionPlaceholder)
       self.additionalTitle = Self.localizedString(for: .additionalTitle)
       self.tableNamePlaceholder = Self.localizedString(for: .tableNamePlaceholder)
       self.hintPlaceholder = Self.localizedString(for: .hintPlaceholder)
       self.descriptionPlaceholder = Self.localizedString(for: .descriptionPlaceholder)
       self.statisticsTitle = Self.localizedString(for: .statisticsTitle)
       self.answersTitle = Self.localizedString(for: .answersTitle)
       self.editTitle = Self.localizedString(for: .editTitle)
       self.saveTitle = Self.localizedString(for: .saveTitle)
       self.cancelTitle = Self.localizedString(for: .cancelTitle)
       self.closeTitle = Self.localizedString(for: .closeTitle)
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
       case tableNamePlaceholder
       case hintPlaceholder
       case descriptionPlaceholder
       case statisticsTitle
       case answersTitle
       case editTitle
       case saveTitle
       case cancelTitle
       case closeTitle
       case errorTitle
       
       var key: String {
           switch self {
           case .navigationTitle: return Strings.details
           case .cardTitle: return Strings.card
           case .wordPlaceholder: return Strings.word
           case .definitionPlaceholder: return Strings.definition
           case .additionalTitle: return Strings.additional
           case .tableNamePlaceholder: return Strings.tableName
           case .hintPlaceholder: return Strings.hint
           case .descriptionPlaceholder: return Strings.description
           case .statisticsTitle: return Strings.statistics
           case .answersTitle: return Strings.answers
           case .editTitle: return Strings.edit
           case .saveTitle: return Strings.save
           case .cancelTitle: return Strings.cancel
           case .closeTitle: return Strings.close
           case .errorTitle: return Strings.error
           }
       }
       
       var capitalized: Bool {
           switch self {
           case .navigationTitle, .wordPlaceholder,
                .definitionPlaceholder, .editTitle,
                .saveTitle, .cancelTitle, .closeTitle:
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
       cardTitle = Self.localizedString(for: .cardTitle)
       wordPlaceholder = Self.localizedString(for: .wordPlaceholder)
       definitionPlaceholder = Self.localizedString(for: .definitionPlaceholder)
       additionalTitle = Self.localizedString(for: .additionalTitle)
       tableNamePlaceholder = Self.localizedString(for: .tableNamePlaceholder)
       hintPlaceholder = Self.localizedString(for: .hintPlaceholder)
       descriptionPlaceholder = Self.localizedString(for: .descriptionPlaceholder)
       statisticsTitle = Self.localizedString(for: .statisticsTitle)
       answersTitle = Self.localizedString(for: .answersTitle)
       editTitle = Self.localizedString(for: .editTitle)
       saveTitle = Self.localizedString(for: .saveTitle)
       cancelTitle = Self.localizedString(for: .cancelTitle)
       closeTitle = Self.localizedString(for: .closeTitle)
       errorTitle = Self.localizedString(for: .errorTitle)
   }
}
