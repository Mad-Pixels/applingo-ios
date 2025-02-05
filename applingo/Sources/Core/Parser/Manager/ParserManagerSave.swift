import Foundation
import GRDB

/// A manager responsible for saving parsed dictionary data to the database.
/// It utilizes the provided database managers to perform insert or update operations
/// for both the dictionary and its associated words.
final class ParserManagerSave {
    private let processDatabase: ProcessDatabase
    private let dictionaryManager: DatabaseManagerDictionary
    private let wordManager: DatabaseManagerWord
    
    init(
        processDatabase: ProcessDatabase,
        dictionaryManager: DatabaseManagerDictionary,
        wordManager: DatabaseManagerWord
    ) {
        self.processDatabase = processDatabase
        self.dictionaryManager = dictionaryManager
        self.wordManager = wordManager
    }
    
    /// Saves the dictionary and words directly in the provided database transaction.
    func saveToDatabase(
        dictionary: ParserModelDictionary,
        words: [ParserModelWord],
        db: Database // <-- Принимаем db напрямую
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
            isLocal: dictionary.isLocal
        )
        
        try dictionaryManager.saveInTransaction(dbDictionary, db: db)
        
        for word in words {
            let dbWord = DatabaseModelWord(
                dictionary: dbDictionary.guid,
                frontText: word.frontText,
                backText: word.backText,
                description: word.description,
                hint: word.hint
            )
            try wordManager.saveInTransaction(dbWord, db: db)
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
