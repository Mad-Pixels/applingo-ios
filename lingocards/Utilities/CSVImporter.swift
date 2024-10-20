import NaturalLanguage
import Foundation
import CoreML

struct CSVImporter {
    static let model: ColumnClassifier = {
        let config = MLModelConfiguration()
        return try! ColumnClassifier(configuration: config)
    }()
    
    static func parseCSV(at url: URL, tableName: String) throws -> [WordItem] {
        var wordItems = [WordItem]()
        
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
        
        var columnLabels: [String]
        do {
            if let classifiedLabels = try classifyColumns(sampleColumnsMatrix: sampleColumnsMatrix) {
                columnLabels = classifiedLabels
            } else {
                Logger.warning("[CSVImporter]: Classifier failed to classify columns, using default column labels")
                columnLabels = ["front_text", "back_text", "hint", "description"]
            }
        } catch {
            Logger.warning("[CSVImporter]: Classifier encountered an error: \(error.localizedDescription), using default column labels")
            columnLabels = ["front_text", "back_text", "hint", "description"]
        }
        
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
            
            let wordItem = WordItem(
                tableName: tableName,
                frontText: ft,
                backText: bt,
                description: description,
                hint: hint
            )
            wordItems.append(wordItem)
        }
        return wordItems
    }
    
    static func classifyColumns(sampleColumnsMatrix: [[String]]) throws -> [String]? {
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
                
                let prediction = try model.prediction(input: input)
                let label = prediction.Label
                
                predictionsCount[label, default: 0] += 1
            }
            
            if let (mostFrequentLabel, _) = predictionsCount.max(by: { $0.value < $1.value }) {
                columnLabels.append(mostFrequentLabel)
            } else {
                return nil
            }
        }
        return columnLabels
    }
    
    static func detectLanguage(for text: String) -> String {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(text)
        if let language = recognizer.dominantLanguage {
            let languageCode = language.rawValue

            let knownLanguages: Set<String> = [
                "de",
                "en",
                "es",
                "fr",
                "he",
                "ru",
                "zh",
                "und"
            ]
            if knownLanguages.contains(languageCode) {
                return languageCode
            } else {
                return "und"
            }
        }
        return "und"
    }
    
    static func parseCSVLine(line: String) -> [String] {
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
}
