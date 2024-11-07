import NaturalLanguage
import Foundation
import Combine
import CoreML
import GRDB

enum CSVManagerError: Error, LocalizedError {
    case databaseConnectionNotEstablished
    case csvReadFailed(String)
    case modelPredictionFailed(String)
    case csvImportFailed(String)
    
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
        let tableName = dictionaryItem?.tableName ?? generateTableName()
        
        let dictionary = dictionaryItem ?? DictionaryItemModel(
            displayName: tableName,
            tableName: generateTableName(),
            description: "Imported from local file: '\(tableName).csv'",
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
        var wordItems = [WordItemModel]()
        
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            let sampleLines = lines.prefix(15)
            var sampleColumnsMatrix = [[String]]()
            
            for line in sampleLines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedLine.isEmpty else { continue }
                
                let columns = parseCSVLine(line: trimmedLine)
                sampleColumnsMatrix.append(columns)
            }
            
            var columnLabels = try classifyColumns(sampleColumnsMatrix: sampleColumnsMatrix) ??
                ["front_text", "back_text", "hint", "description"]
            
            for line in lines {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedLine.isEmpty else { continue }
                
                let columns = parseCSVLine(line: trimmedLine)
                if columns.isEmpty { continue }
                
                if columns.count > columnLabels.count {
                    let additionalLabels = Array(repeating: "description", count: columns.count - columnLabels.count)
                    columnLabels.append(contentsOf: additionalLabels)
                }
                
                var description: String?
                var frontText: String?
                var backText: String?
                var hint: String?
                
                for (index, value) in columns.enumerated() {
                    let columnLabel = index < columnLabels.count ? columnLabels[index] : "description"
                    switch columnLabel {
                    case "front_text":
                        frontText = value
                    case "back_text":
                        backText = value
                    case "hint":
                        hint = value
                    case "description":
                        description = value
                    default:
                        break
                    }
                }
                
                guard let ft = frontText, let bt = backText else { continue }
                
                let wordItem = WordItemModel(
                    tableName: tableName,
                    frontText: ft,
                    backText: bt,
                    description: description,
                    hint: hint
                )
                wordItems.append(wordItem)
            }
            return wordItems
        } catch {
            throw CSVManagerError.csvReadFailed(error.localizedDescription)
        }
    }
    
    private func classifyColumns(sampleColumnsMatrix: [[String]]) throws -> [String]? {
        guard let numberOfColumns = sampleColumnsMatrix.first?.count else { return nil }
        var columnLabels = [String]()
        
        for columnIndex in 0..<numberOfColumns {
            var predictionsCount = [String: Int]()
            
            for row in sampleColumnsMatrix {
                if columnIndex >= row.count { continue }
                
                let text = row[columnIndex]
                let language = detectLanguage(for: text)
                let length = Int64(text.count)
                let isEmpty = text.isEmpty ? "true" : "false"
                
                let input = ColumnClassifierInput(
                    Language: language,
                    Length: length,
                    Column_Index: Int64(columnIndex),
                    Is_Empty: isEmpty
                )
                
                do {
                    let prediction = try model.prediction(input: input)
                    let label = prediction.Label
                    predictionsCount[label, default: 0] += 1
                } catch {
                    throw CSVManagerError.modelPredictionFailed(error.localizedDescription)
                }
            }
            
            if let (mostFrequentLabel, _) = predictionsCount.max(by: { $0.value < $1.value }) {
                columnLabels.append(mostFrequentLabel)
            } else {
                return nil
            }
        }
        return columnLabels
    }
    
    private func detectLanguage(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        if let language = recognizer.dominantLanguage {
            let languageCode = language.rawValue
            let knownLanguages: Set<String> = ["de", "en", "es", "fr", "he", "ru", "zh", "und"]
            return knownLanguages.contains(languageCode) ? languageCode : "und"
        }
        return "und"
    }
    
    private func parseCSVLine(line: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var insideQuotes = false
        var iterator = line.makeIterator()
        
        while let char = iterator.next() {
            if char == "\"" {
                if insideQuotes {
                    if let nextChar = iterator.next() {
                        if nextChar == "\"" {
                            currentField.append("\"")
                        } else {
                            insideQuotes = false
                            if nextChar != "," {
                                currentField.append(nextChar)
                            } else {
                                result.append(currentField)
                                currentField = ""
                            }
                        }
                    } else {
                        insideQuotes = false
                    }
                } else {
                    insideQuotes = true
                }
            } else if char == "," && !insideQuotes {
                result.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        result.append(currentField)
        return result
    }
    
    private func generateTableName() -> String {
        return "dict-\(UUID().uuidString.prefix(8))"
    }
}
