import Foundation

final class DictionaryRemoteDetailsLocale: ObservableObject {
   private enum Strings {
       static let details = "Details"
       static let dictionary = "Dictionary"
       static let displayName = "Display Name"
       static let description = "Description"
       static let category = "Category"
       static let subcategory = "Subcategory"
       static let additional = "Additional"
       static let author = "Author"
       static let createdAt = "Created At"
       static let downloading = "Downloading"
       static let download = "Download"
       static let close = "Close"
       static let error = "Error"
   }
   
   @Published private(set) var navigationTitle: String
   @Published private(set) var dictionaryTitle: String
   @Published private(set) var displayNameTitle: String
   @Published private(set) var descriptionTitle: String
   @Published private(set) var categoryTitle: String
   @Published private(set) var subcategoryTitle: String
   @Published private(set) var additionalTitle: String
   @Published private(set) var authorTitle: String
   @Published private(set) var createdAtTitle: String
   @Published private(set) var downloadingTitle: String
   @Published private(set) var downloadTitle: String
   @Published private(set) var closeTitle: String
   @Published private(set) var errorTitle: String
   
   init() {
       self.navigationTitle = Self.localizedString(for: .navigationTitle)
       self.dictionaryTitle = Self.localizedString(for: .dictionaryTitle)
       self.displayNameTitle = Self.localizedString(for: .displayNameTitle)
       self.descriptionTitle = Self.localizedString(for: .descriptionTitle)
       self.categoryTitle = Self.localizedString(for: .categoryTitle)
       self.subcategoryTitle = Self.localizedString(for: .subcategoryTitle)
       self.additionalTitle = Self.localizedString(for: .additionalTitle)
       self.authorTitle = Self.localizedString(for: .authorTitle)
       self.createdAtTitle = Self.localizedString(for: .createdAtTitle)
       self.downloadingTitle = Self.localizedString(for: .downloadingTitle)
       self.downloadTitle = Self.localizedString(for: .downloadTitle)
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
       case navigationTitle, dictionaryTitle, displayNameTitle, descriptionTitle
       case categoryTitle, subcategoryTitle, additionalTitle, authorTitle
       case createdAtTitle, downloadingTitle, downloadTitle, closeTitle, errorTitle
       
       var key: String {
           switch self {
           case .navigationTitle: return Strings.details
           case .dictionaryTitle: return Strings.dictionary
           case .displayNameTitle: return Strings.displayName
           case .descriptionTitle: return Strings.description
           case .categoryTitle: return Strings.category
           case .subcategoryTitle: return Strings.subcategory
           case .additionalTitle: return Strings.additional
           case .authorTitle: return Strings.author
           case .createdAtTitle: return Strings.createdAt
           case .downloadingTitle: return Strings.downloading
           case .downloadTitle: return Strings.download
           case .closeTitle: return Strings.close
           case .errorTitle: return Strings.error
           }
       }
       
       var capitalized: Bool {
           switch self {
           case .navigationTitle, .displayNameTitle,
                .downloadTitle, .closeTitle:
               return true
           default:
               return false
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
       displayNameTitle = Self.localizedString(for: .displayNameTitle)
       descriptionTitle = Self.localizedString(for: .descriptionTitle)
       categoryTitle = Self.localizedString(for: .categoryTitle)
       subcategoryTitle = Self.localizedString(for: .subcategoryTitle)
       additionalTitle = Self.localizedString(for: .additionalTitle)
       authorTitle = Self.localizedString(for: .authorTitle)
       createdAtTitle = Self.localizedString(for: .createdAtTitle)
       downloadingTitle = Self.localizedString(for: .downloadingTitle)
       downloadTitle = Self.localizedString(for: .downloadTitle)
       closeTitle = Self.localizedString(for: .closeTitle)
       errorTitle = Self.localizedString(for: .errorTitle)
   }
}
