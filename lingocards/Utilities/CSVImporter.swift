import Foundation
import CoreML
import NaturalLanguage

struct CSVImporter {
    // Загрузка модели один раз при инициализации структуры
    static let model: ColumnClassifier = {
        let config = MLModelConfiguration()
        return try! ColumnClassifier(configuration: config)
    }()
    
    static func parseCSV(at url: URL, tableName: String) throws -> [WordItem] {
        var wordItems = [WordItem]()
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        // Читаем первые 10 строк для определения меток колонок
        var sampleColumnsMatrix = [[String]]()
        for line in lines.prefix(10) {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty else { continue }
            let columns = parseCSVLine(line: trimmedLine)
            sampleColumnsMatrix.append(columns)
        }
        
        // Определяем метки колонок с помощью модели
        guard let columnLabels = try classifyColumns(sampleColumnsMatrix: sampleColumnsMatrix) else {
            throw NSError(domain: "ColumnClassification", code: -1, userInfo: [NSLocalizedDescriptionKey: "Не удалось классифицировать колонки"])
        }
        
        // Парсим остальные строки с использованием определенных меток
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty else { continue }
            
            let columns = parseCSVLine(line: trimmedLine)
            if columns.count != columnLabels.count { continue }
            
            var frontText: String?
            var backText: String?
            var hint: String?
            var description: String?
            
            for (index, columnLabel) in columnLabels.enumerated() {
                let value = columns[index]
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
            
            // Проверяем, что обязательные поля не пустые
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
        // Предполагаем, что во всех строках одинаковое количество колонок
        guard let numberOfColumns = sampleColumnsMatrix.first?.count else { return nil }
        var columnLabels = [String]()
        
        for columnIndex in 0..<numberOfColumns {
            var predictionsCount = [String: Int]()
            
            for row in sampleColumnsMatrix {
                if columnIndex >= row.count { continue }
                let text = row[columnIndex]
                let language = detectLanguage(for: text)
                let length = Int64(text.count)  // Преобразуем длину текста в Int64
                let isEmpty = text.isEmpty ? "true" : "false"  // Преобразуем булевое значение в строку
                
                // Создаем экземпляр ColumnClassifierInput
                let input = ColumnClassifierInput(
                    Language: language,
                    Length: length,
                    Column_Index: Int64(columnIndex),  // Преобразуем индекс колонки в Int64
                    Is_Empty: isEmpty
                )
                
                // Получаем предсказание
                let prediction = try model.prediction(input: input)
                let label = prediction.Label
                
                predictionsCount[label, default: 0] += 1
            }
            
            // Выбираем наиболее частую метку для данного столбца
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

            // Множество известных языков из обучающего набора данных
            let knownLanguages: Set<String> = ["de", "en", "es", "fr", "he", "ru", "und", "zh"]

            // Если язык не известен, возвращаем "und"
            if knownLanguages.contains(languageCode) {
                return languageCode
            } else {
                return "und"
            }
        }
        return "und" // неопределенный язык
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
