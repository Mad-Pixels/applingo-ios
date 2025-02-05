import Foundation
import GRDB

/// A manager responsible for saving parsed dictionary data to the database.
/// It utilizes the provided database managers to perform insert or update operations
/// for both the dictionary and its associated words.
final class TableParserManagerSave {
    
    // MARK: - Properties
    
    /// The database operations processor.
    private let processDatabase: ProcessDatabase
    /// Manager for handling dictionary-related database operations.
    private let dictionaryManager: DatabaseManagerDictionary
    /// Manager for handling word-related database operations.
    private let wordManager: DatabaseManagerWord

    // MARK: - Initialization
    
    /// Initializes a new instance of `TableParserManagerSave` with the given parameters.
    ///
    /// - Parameters:
    ///   - processDatabase: An instance of `ProcessDatabase` used to wrap database operations.
    ///   - dictionaryManager: The manager responsible for dictionary CRUD operations.
    ///   - wordManager: The manager responsible for word CRUD operations.
    init(
        processDatabase: ProcessDatabase,
        dictionaryManager: DatabaseManagerDictionary,
        wordManager: DatabaseManagerWord
    ) {
        self.processDatabase = processDatabase
        self.dictionaryManager = dictionaryManager
        self.wordManager = wordManager
    }
    
    // MARK: - Public Methods
    
    /// Saves the parsed dictionary and its associated words to the database.
    ///
    /// This method performs the following steps:
    /// 1. Converts the table parser model (`TableParserModelDictionary`) into a database model (`DatabaseModelDictionary`).
    /// 2. Saves the dictionary to the database using the `dictionaryManager`.
    /// 3. Iterates through each word in the provided array, converts it into a database model (`DatabaseModelWord`),
    ///    and saves it using the `wordManager`.
    /// 4. Logs the successful completion of the save operation.
    ///
    /// - Parameters:
    ///   - dictionary: The dictionary model containing metadata parsed from the file.
    ///   - words: An array of word models parsed from the file.
    /// - Throws: An error if any database operation (save/update) fails.
    func saveToDatabase(dictionary: TableParserModelDictionary, words: [TableParserModelWord]) throws {
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
        
        try dictionaryManager.save(dbDictionary)
        Logger.debug(
            "[Save]: Dictionary saved via manager",
            metadata: [
                "id": dbDictionary.id ?? -1,
                "guid": dbDictionary.guid,
                "name": dbDictionary.name
            ]
        )
        
        for word in words {
            let dbWord = DatabaseModelWord(
                dictionary: dbDictionary.guid,
                frontText: word.frontText,
                backText: word.backText,
                description: word.description,
                hint: word.hint
            )
            try wordManager.upsert(dbWord)
        }
        
        Logger.debug(
            "[Save]: Successfully saved items",
            metadata: [
                "dictionary_guid": dictionary.guid,
                "saved_words_count": "\(words.count)"
            ]
        )
    }
}
