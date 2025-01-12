import Foundation

final class DictionaryRemoteFilterLocale: ObservableObject {
   private enum Strings {
       static let filter = "Filter"
       static let dictionary = "Dictionary"
       static let sortBy = "SortBy"
       static let save = "Save"
       static let reset = "Reset"
       static let close = "Close"
       static let error = "Error"
   }
   
   @Published private(set) var navigationTitle: String
   @Published private(set) var dictionaryTitle: String
   @Published private(set) var sortByTitle: String
   @Published private(set) var saveTitle: String
   @Published private(set) var resetTitle: String
   @Published private(set) var closeTitle: String
   @Published private(set) var errorTitle: String
   
   init() {
       self.navigationTitle = Self.localizedString(for: .navigationTitle)
       self.dictionaryTitle = Self.localizedString(for: .dictionaryTitle)
       self.sortByTitle = Self.localizedString(for: .sortByTitle)
       self.saveTitle = Self.localizedString(for: .saveTitle)
       self.resetTitle = Self.localizedString(for: .resetTitle)
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
       case dictionaryTitle
       case sortByTitle
       case saveTitle
       case resetTitle
       case closeTitle
       case errorTitle
       
       var key: String {
           switch self {
           case .navigationTitle: return Strings.filter
           case .dictionaryTitle: return Strings.dictionary
           case .sortByTitle: return Strings.sortBy
           case .saveTitle: return Strings.save
           case .resetTitle: return Strings.reset
           case .closeTitle: return Strings.close
           case .errorTitle: return Strings.error
           }
       }
       
       var capitalized: Bool {
           switch self {
           case .navigationTitle, .saveTitle,
                .resetTitle, .closeTitle:
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
       dictionaryTitle = Self.localizedString(for: .dictionaryTitle)
       sortByTitle = Self.localizedString(for: .sortByTitle)
       saveTitle = Self.localizedString(for: .saveTitle)
       resetTitle = Self.localizedString(for: .resetTitle)
       closeTitle = Self.localizedString(for: .closeTitle)
       errorTitle = Self.localizedString(for: .errorTitle)
   }
}
