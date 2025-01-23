import Foundation
import GRDB

enum CSVManagerError: Error, LocalizedError {
    case databaseConnectionNotEstablished
    case csvReadFailed(String)
    case csvImportFailed(String)
    case notEnoughColumns
    
    var errorDescription: String? {
        switch self {
        case .notEnoughColumns:
            return "CSV must contain at least 2 columns (front_text, back_text)"
        case .csvReadFailed(let details):
            return "Failed to read CSV file. Details: \(details)"
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        case .databaseConnectionNotEstablished:
            return "Database connection is not established"
        }
    }
}

final class CSVManager {
    static let shared = CSVManager()
    private init() {}
    
    func parse(
        url: URL,
        dictionaryItem: DatabaseModelDictionary? = nil
    ) throws -> (dictionary: DatabaseModelDictionary, words: [DatabaseModelWord]) {
        let tableName = "dict-\(UUID().uuidString.prefix(8))"
        
        let dictionary = dictionaryItem.map { existing in
            DatabaseModelDictionary(
                guid: existing.guid,
                name: existing.name,
                author: existing.author,
                category: existing.category,
                subcategory: existing.subcategory,
                description: existing.description
            )
        } ?? DatabaseModelDictionary(
            guid: url.lastPathComponent,
            name: url.deletingPathExtension().lastPathComponent,
            author: "local user",
            category: "Local",
            subcategory: "personal",
            description: "Imported from local file: '\(url.lastPathComponent)'"
        )
        
        let words = try parseCSV(at: url, tableName: tableName)
        Logger.debug("[CSVManager]: Parsed \(words.count) words from CSV")
        return (dictionary, words)
    }
    
    func saveToDatabase(dictionary: DatabaseModelDictionary, words: [DatabaseModelWord]) throws {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            throw CSVManagerError.databaseConnectionNotEstablished
        }
        
        try dbQueue.write { db in
            try dictionary.insert(db)
            Logger.debug("[CSVManager]: Created dictionary entry: \(dictionary.guid)")
            
            for var wordItem in words {
                wordItem.dictionary = dictionary.guid
                try wordItem.insert(db)
            }
            Logger.debug("[CSVManager]: Inserted \(words.count) word items for table \(dictionary.guid)")
        }
    }
    
    private func parseCSV(at url: URL, tableName: String) throws -> [DatabaseModelWord] {
        let content = try String(contentsOf: url, encoding: .utf8)
        let separator = detectCsvSeparator(in: content)
        Logger.debug("[CSVManager]: Detected separator: \(separator)")
        
        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else {
            throw CSVManagerError.csvReadFailed("File is empty")
        }
        return try parseCsvLines(
            lines: Array(lines),
            separator: separator,
            tableName: tableName
        )
    }
}
