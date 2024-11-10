import Foundation
import NaturalLanguage
import GRDB

enum CSVManagerError: Error, LocalizedError {
    case databaseConnectionNotEstablished
    case csvReadFailed(String)
    case csvImportFailed(String)
    case notEnoughColumns
    case invalidColumnStructure
    
    var errorDescription: String? {
        switch self {
        case .databaseConnectionNotEstablished:
            return "Database connection is not established"
        case .csvReadFailed(let details):
            return "Failed to read CSV file. Details: \(details)"
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        case .notEnoughColumns:
            return "CSV must contain at least 2 columns (front_text, back_text)"
        case .invalidColumnStructure:
            return "Invalid column structure: unable to identify required columns"
        }
    }
}

final class CSVManager {
    static let shared = CSVManager()
    private init() {}
    
    func parse(url: URL, dictionaryItem: DictionaryItemModel? = nil) throws -> (dictionary: DictionaryItemModel, words: [WordItemModel]) {
        let tableName = generateTableName()
        
        let dictionary = dictionaryItem.map { existing in
            DictionaryItemModel(
                displayName: existing.displayName,
                tableName: tableName,
                description: existing.description,
                category: existing.category,
                subcategory: existing.subcategory,
                author: existing.author
            )
        } ?? DictionaryItemModel(
            displayName: url.deletingPathExtension().lastPathComponent,
            tableName: tableName,
            description: "Imported from local file: '\(url.lastPathComponent)'",
            category: "Local",
            subcategory: "personal",
            author: "local user"
        )
        
        let words = try parseCSV(at: url, tableName: tableName)
        Logger.debug("[CSVManager]: Parsed \(words.count) words from CSV")
        return (dictionary, words)
    }
    
    func saveToDatabase(dictionary: DictionaryItemModel, words: [WordItemModel]) throws {
        guard let dbQueue = DatabaseManager.shared.databaseQueue else {
            throw CSVManagerError.databaseConnectionNotEstablished
        }
        
        try dbQueue.write { db in
            try dictionary.insert(db)
            Logger.debug("[CSVManager]: Created dictionary entry: \(dictionary.tableName)")
            
            for var wordItem in words {
                wordItem.tableName = dictionary.tableName
                try wordItem.insert(db)
            }
            Logger.debug("[CSVManager]: Inserted \(words.count) word items for table \(dictionary.tableName)")
        }
    }
    
    private func parseCSV(at url: URL, tableName: String) throws -> [WordItemModel] {
        let content = try String(contentsOf: url, encoding: .utf8)
        let separator = detectCsvSeparator(in: content)
        Logger.debug("[CSVManager]: Detected separator: \(separator)")
        
        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        guard !lines.isEmpty else {
            throw CSVManagerError.csvReadFailed("File is empty")
        }
        let startIndex = lines[0].lowercased().contains("front") ||
                        lines[0].lowercased().contains("text") ? 1 : 0
        let sampleLines = Array(lines[startIndex..<min(startIndex + 30, lines.count)])
            .map { parseCsvLine(line: $0, separator: separator) }
        let classifier = CsvColumnClassifier(sampleData: sampleLines)
        let columnTypes = classifier.classifyColumns()
        
        guard columnTypes.contains("front_text") && columnTypes.contains("back_text") else {
            throw CSVManagerError.notEnoughColumns
        }
        return try parseCsvLines(
            lines: Array(lines[startIndex...]),
            columnTypes: columnTypes,
            separator: separator,
            tableName: tableName
        )
    }
}
