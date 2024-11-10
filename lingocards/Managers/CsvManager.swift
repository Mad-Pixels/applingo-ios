import NaturalLanguage
import Foundation
import Combine
import CoreML
import GRDB

enum CSVManagerError: Error, LocalizedError {
    case databaseConnectionNotEstablished
    case modelPredictionFailed(String)
    case csvImportFailed(String)
    case csvReadFailed(String)
    case notEnoughColumns
   
    var errorDescription: String? {
        switch self {
        case .databaseConnectionNotEstablished:
            return "Database connection is not established."
        case .csvReadFailed(let details):
            return "Failed to read CSV file. Details: \(details)"
        case .modelPredictionFailed(let details):
           return "Model prediction failed. Details: \(details)"
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        case .notEnoughColumns:
            return "CSV must contain at least 2 columns (front_text, back_text)"
        }
    }
}

class CSVManager {
    static let shared = CSVManager()
    private init() {}
   
    private let model: ColumnClassifier = {
        let config = MLModelConfiguration()
        return try! ColumnClassifier(configuration: config)
    }()
   
    func parse(url: URL, dictionaryItem: DictionaryItemModel? = nil) throws -> (dictionary: DictionaryItemModel, words: [WordItemModel]) {
        let tableName = generateTableName()
        
        let dictionary: DictionaryItemModel
        if let existingDictionary = dictionaryItem {
            dictionary = DictionaryItemModel(
                displayName: existingDictionary.displayName,
                tableName: tableName,
                description: existingDictionary.description,
                category: existingDictionary.category,
                subcategory: existingDictionary.subcategory,
                author: existingDictionary.author
            )
        } else {
            dictionary = DictionaryItemModel(
                displayName: url.deletingPathExtension().lastPathComponent,
                tableName: tableName,
                description: "Imported from local file: '\(url.lastPathComponent)'",
                category: "Local",
                subcategory: "personal",
                author: "local user"
            )
        }
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
    
    private struct ColumnsStructure {
        let columnTypes: [String]
        let hasRequiredColumns: Bool
       
        init(columnTypes: [String]) {
            self.columnTypes = columnTypes
            self.hasRequiredColumns = columnTypes.contains("front_text") && columnTypes.contains("back_text")
        }
    }
    
    private func analyzeColumnsStructure(_ sampleData: [[String]]) throws -> ColumnsStructure {
        guard let numberOfColumns = sampleData.first?.count else {
            throw CSVManagerError.csvReadFailed("No columns found in sample data")
        }
        
        var columnTypes = [String]()
        for columnIndex in 0..<numberOfColumns {
            var columnValues = [String]()
            var columnTotalLength: Int64 = 0
            var columnEmptyCount = 0
            
            for row in sampleData {
                guard columnIndex < row.count else { continue }
                let value = row[columnIndex]
                columnValues.append(value)
                columnTotalLength += Int64(value.count)
                if value.isEmpty {
                    columnEmptyCount += 1
                }
            }
            let columnLanguage = detectCsvLanguage(for: columnValues.joined(separator: " "))
            let columnIsEmpty = columnEmptyCount > columnValues.count / 2 ? "true" : "false"
            let columnAvgLength = columnTotalLength / Int64(max(1, columnValues.count))
            let relativePosition = Double(columnIndex) / Double(max(1, numberOfColumns - 1))

            do {
                Logger.debug("[CSVManager]: Creating input - Language: \(columnLanguage), Length: \(columnAvgLength), Column_Index: \(columnIndex), Relative_Position: \(relativePosition), Is_Empty: \(columnIsEmpty)")
                
                let input = ColumnClassifierInput(
                    Language: columnLanguage,
                    Length: columnAvgLength,
                    Column_Index: Int64(columnIndex),
                    Relative_Position: relativePosition,
                    Is_Empty: columnIsEmpty
                )
                
                Logger.debug("[CSVManager]: Created input successfully")
                let prediction = try model.prediction(input: input)
                Logger.debug("[CSVManager]: Got prediction: \(prediction.Label)")
                
                columnTypes.append(prediction.Label)
            } catch {
                print("[CSVManager]: Failed to create prediction - Error: \(error)")
                print("[CSVManager]: Input values - Language: \(columnLanguage), Length: \(columnAvgLength), Column_Index: \(columnIndex), Relative_Position: \(relativePosition), Is_Empty: \(columnIsEmpty)")
                throw CSVManagerError.modelPredictionFailed(error.localizedDescription)
            }
        }
        return ColumnsStructure(columnTypes: columnTypes)
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
        
        let sampleSize = 30
        let sampleLines = Array(lines[startIndex..<min(startIndex + sampleSize, lines.count)])
            .map { parseCsvLine(line: $0, separator: separator) }
        let structure = try analyzeColumnsStructure(sampleLines)
        
        guard structure.hasRequiredColumns else {
            throw CSVManagerError.notEnoughColumns
        }
        return try parseCsvLines(
            lines: Array(lines[startIndex...]),
            columnTypes: structure.columnTypes,
            separator: separator,
            tableName: tableName
        )
    }
}
