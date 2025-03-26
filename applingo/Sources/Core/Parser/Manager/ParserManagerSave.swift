import Foundation
import GRDB

/// A class responsible for saving parsed dictionary data to the database.
/// It utilizes DatabaseManagerTransaction to perform atomic operations
/// for both the dictionary and its associated words within a single transaction.
final class ParserManagerSave {
   
   // MARK: - Properties
   
   private let processDatabase: ProcessDatabase
   private let transactionManager: DatabaseManagerTransaction
   
   // MARK: - Initialization
   
   /// Creates a new save manager with the given dependencies.
   /// - Parameters:
   ///   - processDatabase: An instance of `ProcessDatabase` used for handling DB operations.
   ///   - transactionManager: Manager for handling atomic database transactions.
   init(
       processDatabase: ProcessDatabase,
       transactionManager: DatabaseManagerTransaction
   ) {
       self.processDatabase = processDatabase
       self.transactionManager = transactionManager
   }
   
   // MARK: - Public Methods
   
   /// Saves the dictionary and words directly in the provided database transaction.
   /// - Parameters:
   ///   - dictionary: The dictionary model containing metadata (ParserModelDictionary).
   ///   - words: The array of word entries to be stored (ParserModelWord).
   ///   - db: The database instance from the current transaction.
   /// - Throws: DatabaseError for database operations failures, TableParserError for other issues.
   func saveToDatabase(
       dictionary: ParserModelDictionary,
       words: [ParserModelWord],
       db: Database
   ) throws {
       let dbDictionary = DatabaseModelDictionary(
           guid: dictionary.guid,
           name: dictionary.name,
           topic: dictionary.topic,
           author: dictionary.author,
           category: dictionary.category,
           subcategory: dictionary.subcategory,
           description: dictionary.description,
           level: dictionary.level,
           count: words.count,
           isLocal: dictionary.isLocal
       )
       
       let dbWords = words.map { word in
           // Извлекаем код для backText из dictionary.subcategory
           let parts = dictionary.subcategory.split(separator: "-")
           let backLangCode = parts.count >= 2 ? String(parts[1]) : "en" // По умолчанию "en" если формат неправильный
           
           return DatabaseModelWord(
               subcategory: dbDictionary.subcategory,
               dictionary: dbDictionary.guid,
               frontText: word.frontText,
               backText: word.backText,
               description: word.description,
               hint: word.hint,
               backLangCode: backLangCode // Используем только извлеченный код языка
           )
       }
       
       try transactionManager.save(
           dictionary: dbDictionary,
           words: dbWords,
           db: db
       )
       
       Logger.debug(
           "[Parser]: Dictionary and words saved successfully",
           metadata: [
               "guid": dictionary.guid,
               "words_count": String(words.count)
           ]
       )
       
       // Send notifications after successful save operation
       Task {
           await notifyDictionaryUpdate()
           await notifyWordsUpdate()
       }
   }
   
   // MARK: - Private Methods
   
   /// Notifies observers about an update to the dictionary list.
   ///
   /// This method posts a notification on the main actor, allowing UI components and other parts
   /// of the application to refresh their data based on the update.
   private func notifyDictionaryUpdate() async {
       await MainActor.run {
           Logger.debug("[Parser]: Notifying about dictionary update")
           NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
       }
   }
   
   /// Notifies observers about an update to the words list.
   ///
   /// This method posts a notification on the main actor, allowing UI components and other parts
   /// of the application to refresh their data based on the update.
   private func notifyWordsUpdate() async {
       await MainActor.run {
           Logger.debug("[Parser]: Notifying about words update")
           NotificationCenter.default.post(name: .wordListShouldUpdate, object: nil)
       }
   }
}
