import Foundation
import GRDB

/// A class responsible for saving parsed dictionary data to the database.
final class TableParserManagerSave {
   
    /// The database operations processor
    private let processDatabase: ProcessDatabase
   
    /// Creates a new save manager with the given `ProcessDatabase`.
    /// - Parameter processDatabase: An instance of `ProcessDatabase` used for handling DB operations.
    init(processDatabase: ProcessDatabase) {
        self.processDatabase = processDatabase
    }
   
    /// Saves the dictionary and words into the database.
    /// - Parameters:
    ///   - dictionary: The dictionary model containing metadata (TableParserModelDictionary).
    ///   - words: The array of word entries to be stored (TableParserModelWord).
    /// - Throws: TableParserError if database connection fails, DatabaseError for other database operations.
    func saveToDatabase(dictionary: TableParserModelDictionary, words: [TableParserModelWord]) throws {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            throw TableParserError.fileReadFailed("Database connection is not established")
        }
       
        try dbQueue.write { db in
            let dbDictionary = DatabaseModelDictionary(
                guid: dictionary.guid,
                name: dictionary.name,
                topic: dictionary.topic,
                author: dictionary.author,
                category: dictionary.category,
                subcategory: dictionary.subcategory,
                description: dictionary.description,
                level: dictionary.level,
                isLocal: dictionary.isLocal
            )
           
            do {
                try dbDictionary.insert(db)
                Logger.debug(
                    "[Dictionary]: Dictionary saved",
                    metadata: [
                        "id": dbDictionary.id ?? -1,
                        "guid": dbDictionary.guid,
                        "name": dbDictionary.name
                    ]
                )
            } catch let error as GRDB.DatabaseError {
                if error.resultCode == .SQLITE_CONSTRAINT {
                    throw DatabaseError.duplicateDictionary(dictionary: dbDictionary.name)
                }
                throw DatabaseError.saveFailed(details: error.localizedDescription)
            } catch {
                throw DatabaseError.saveFailed(details: error.localizedDescription)
            }
           
            for word in words {
                let dbWord = DatabaseModelWord(
                    dictionary: dbDictionary.guid,
                    frontText: word.frontText,
                    backText: word.backText,
                    description: word.description,
                    hint: word.hint
                )
               
                try dbWord.upsert(db)
            }
           
            Logger.debug(
                "[ParserManagerSave]: Successfully saved items",
                metadata: [
                    "dictionary_guid": dictionary.guid,
                    "saved_words_count": "\(words.count)"
                ]
            )
        }
    }
}
