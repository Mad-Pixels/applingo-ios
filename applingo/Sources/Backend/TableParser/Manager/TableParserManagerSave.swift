import Foundation

/// A manager responsible for saving parsed table data into a database or any storage,
/// utilizing the `ProcessDatabase` for asynchronous operations.
final class TableParserManagerSave {
    
    private let processDatabase: ProcessDatabase
    
    /// Creates a new save manager with the given `ProcessDatabase`.
    /// - Parameter processDatabase: An instance of `ProcessDatabase` used for handling DB operations.
    init(processDatabase: ProcessDatabase) {
        self.processDatabase = processDatabase
    }
    
    /// Saves the dictionary and words into the database asynchronously.
    /// - Parameters:
    ///   - dictionary: The dictionary model containing metadata (TableParserModelDictionary).
    ///   - words: The array of word entries to be stored (TableParserModelWord).
    func saveToDatabase(dictionary: TableParserModelDictionary, words: [TableParserModelWord]) {
        Logger.debug(
            "[ParserManagerSave]: Saving to database",
            metadata: [
                "dictionary_guid": dictionary.guid,
                "words_count": "\(words.count)"
            ]
        )
        
        processDatabase.performDatabaseOperation(
            {
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
                    
                    try dbDictionary.insert(db)
                    
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
                }
                
                return words.count
            },
            success: { count in
                Logger.debug(
                    "[ParserManagerSave]: Successfully saved items",
                    metadata: [
                        "saved_count": "\(count)"
                    ]
                )
            },
            screen: .DictionaryImport,
            metadata: [
                "dictionary_guid": dictionary.guid
            ],
            completion: { result in
                switch result {
                case .success:
                    Logger.debug("[ParserManagerSave]: Completion success")
                case .failure(let error):
                    Logger.debug(
                        "[ParserManagerSave]: Completion error",
                        metadata: [
                            "error": "\(error)"
                        ]
                    )
                }
            }
        )
    }
}
