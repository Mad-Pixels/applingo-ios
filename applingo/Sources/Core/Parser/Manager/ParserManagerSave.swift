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
           DatabaseModelWord(
            subcategory: dbDictionary.subcategory,
            dictionary: dbDictionary.guid,
               frontText: word.frontText,
               backText: word.backText,
               description: word.description,
               hint: word.hint
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
   }
}
