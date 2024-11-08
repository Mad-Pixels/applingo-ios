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
            // Читаем содержимое файла
            let content = try String(contentsOf: url, encoding: .utf8)
            
            // Определяем разделитель на основе содержимого
            let separator = detectSeparator(in: content)
            Logger.debug("[CSVManager]: Detected separator: \(separator)")
            
            // Разбиваем на строки и очищаем от пустых
            let lines = content.components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
            
            // Проверяем минимальное количество строк
            guard !lines.isEmpty else {
                throw CSVManagerError.csvReadFailed("File is empty")
            }
            
            // Берем первые строки для анализа (пропускаем первую если это заголовок)
            let startIndex = lines[0].lowercased().contains("front") ||
                            lines[0].lowercased().contains("text") ? 1 : 0
            let sampleLines = Array(lines[startIndex..<min(startIndex + 15, lines.count)])
            
            // Создаем матрицу значений для анализа
            var sampleColumnsMatrix = [[String]]()
            for line in sampleLines {
                let columns = parseCSVLine(line: line, separator: separator)
                if !columns.isEmpty {
                    sampleColumnsMatrix.append(columns)
                }
            }
            
            // Проверяем что у нас есть данные для анализа
            guard !sampleColumnsMatrix.isEmpty else {
                throw CSVManagerError.csvReadFailed("No valid data found for analysis")
            }
            
            // Определяем типы колонок через модель
            var columnLabels = try classifyColumns(sampleColumnsMatrix: sampleColumnsMatrix) ??
                ["front_text", "back_text", "hint", "description"]
            
            // Обрабатываем все строки файла
            for line in lines[startIndex...] {
                let columns = parseCSVLine(line: line, separator: separator)
                if columns.isEmpty { continue }
                
                // Если колонок больше чем меток, добавляем метки description
                if columns.count > columnLabels.count {
                    let additionalLabels = Array(repeating: "description", count: columns.count - columnLabels.count)
                    columnLabels.append(contentsOf: additionalLabels)
                }
                
                // Маппим значения в соответствующие поля
                var description: String?
                var frontText: String?
                var backText: String?
                var hint: String?
                
                for (index, value) in columns.enumerated() {
                    let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmedValue.isEmpty else { continue }
                    
                    let columnLabel = index < columnLabels.count ? columnLabels[index] : "description"
                    switch columnLabel {
                    case "front_text":
                        frontText = trimmedValue
                    case "back_text":
                        backText = trimmedValue
                    case "hint":
                        hint = trimmedValue
                    case "description":
                        // Если description уже есть, добавляем новое значение через разделитель
                        if let existingDescription = description {
                            description = existingDescription + " | " + trimmedValue
                        } else {
                            description = trimmedValue
                        }
                    default:
                        break
                    }
                }
                
                // Создаем WordItem только если есть обязательные поля
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
            
            Logger.debug("[CSVManager]: Successfully parsed \(wordItems.count) items")
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
    
    private func parseCSVLine(line: String, separator: String) -> [String] {
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
                            // Используем переданный разделитель
                            if String(nextChar) != separator {
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
            } else if String(char) == separator && !insideQuotes {
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
    
    //
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    
    private func detectSeparator(in content: String) -> String {
        // Возможные разделители
        let possibleSeparators = [",", ";", "\t", "|"]
        
        // Берем первые несколько строк для анализа
        let lines = content.components(separatedBy: .newlines)
            .prefix(10)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        var separatorScores: [String: Int] = [:]
        
        // Для каждого возможного разделителя
        for separator in possibleSeparators {
            for line in lines {
                let components = line.components(separatedBy: separator)
                // Если строка разбивается на 2-4 части - это хороший кандидат
                if (2...4).contains(components.count) {
                    separatorScores[separator, default: 0] += 1
                }
            }
        }
        
        // Выбираем разделитель который сработал для большинства строк
        if let (bestSeparator, _) = separatorScores.max(by: { $0.value < $1.value }) {
            return bestSeparator
        }
        
        // Если не смогли определить, используем запятую по умолчанию
        return ","
    }
}
