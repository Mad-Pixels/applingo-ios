import Foundation

final class CSVManager {
    static let shared = CSVManager()
    private init() {}
    
    func parse(
        url: URL,
        dictionaryItem: DatabaseModelDictionary? = nil
    ) throws -> (dictionary: DatabaseModelDictionary, words: [DatabaseModelWord]) {
        try DictionaryImporter.shared.imports(
            from: url,
            dictionaryMetadata: dictionaryItem
        )
    }
    
    func saveToDatabase(dictionary: DatabaseModelDictionary, words: [DatabaseModelWord]) throws {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            throw DictionaryParserError.fileReadFailed("Database connection is not established")
        }
        
        try dbQueue.write { db in
            try dictionary.insert(db)
            
            for var word in words {
                word.dictionary = dictionary.guid
                try word.insert(db)
            }
        }
    }
}
