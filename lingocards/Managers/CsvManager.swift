import Foundation
import NaturalLanguage
import GRDB

// MARK: - Errors
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

// MARK: - Column Analysis
struct ColumnAnalysis {
    let values: [String]
    let language: String
    let avgLength: Double
    let emptyRatio: Double
    let specialCharRatio: Double
    let position: Int
    
    init(values: [String], position: Int, totalColumns: Int) {
        self.values = values
        self.position = position
        
        // Language detection
        let text = values.joined(separator: " ")
        self.language = detectCsvLanguage(for: text)
        
        // Length analysis
        let totalLength = values.reduce(0) { $0 + $1.count }
        self.avgLength = Double(totalLength) / Double(max(1, values.count))
        
        // Empty values analysis
        let emptyCount = values.filter { $0.isEmpty }.count
        self.emptyRatio = Double(emptyCount) / Double(max(1, values.count))
        
        // Special characters analysis
        let specialChars = CharacterSet.punctuationCharacters
            .union(.symbols)
            .union(.nonBaseCharacters)
        
        let specialCharCount = values.reduce(0) { count, str in
            count + str.unicodeScalars.filter { specialChars.contains($0) }.count
        }
        self.specialCharRatio = Double(specialCharCount) / Double(max(1, values.joined().count))
    }
}

// MARK: - Column Classifier
final class ColumnClassifier {
    private let columns: [ColumnAnalysis]
    
    init(sampleData: [[String]]) {
        guard let columnCount = sampleData.first?.count else {
            columns = []
            return
        }
        
        self.columns = (0..<columnCount).map { columnIndex in
            let columnValues = sampleData.compactMap { row in
                columnIndex < row.count ? row[columnIndex] : nil
            }
            return ColumnAnalysis(
                values: columnValues,
                position: columnIndex,
                totalColumns: columnCount
            )
        }
    }
    
    private struct ColumnCharacteristics {
        let values: [String]
        let latinRatio: Double
        let nonLatinRatio: Double
        let avgWordLength: Double
        let emptyRatio: Double
        let specialCharRatio: Double
        let position: Int
        let multilineRatio: Double
        let uniqueValuesRatio: Double
        let wordCount: Double  // Среднее количество слов в значении
        
        var isMainlyLatin: Bool {
            return latinRatio > 0.7
        }
        
        var isMainlyNonLatin: Bool {
            return nonLatinRatio > 0.7
        }
    }
    
    func classifyColumns() -> [String] {
        guard columns.count >= 2 else { return [] }
        
        let columnAnalyses = columns.enumerated().map { index, column in
            analyzeColumn(column, at: index)
        }
        
        // 1. Сначала ищем наиболее вероятную пару front_text/back_text
        let (frontIndex, backIndex) = findBestTranslationPair(analyses: columnAnalyses)
        
        var result = [String?](repeating: nil, count: columns.count)
        if let frontIdx = frontIndex, let backIdx = backIndex {
            result[frontIdx] = "front_text"
            result[backIdx] = "back_text"
            
            // 2. Из оставшихся колонок выбираем hint и description
            let remainingIndices = Set(0..<columns.count)
                .subtracting([frontIdx, backIdx])
            
            // Анализируем оставшиеся колонки
            var bestHintScore = -Double.infinity
            var hintIndex: Int?
            
            for index in remainingIndices {
                let score = scoreForHint(analysis: columnAnalyses[index])
                if score > bestHintScore {
                    bestHintScore = score
                    hintIndex = index
                }
            }
            
            // Присваиваем оставшимся колонкам их типы
            for index in remainingIndices {
                if index == hintIndex {
                    result[index] = "hint"
                } else {
                    result[index] = "description"
                }
            }
        }
        
        return result.map { $0 ?? "unknown" }
    }
    
    private func analyzeColumn(_ column: ColumnAnalysis, at position: Int) -> ColumnCharacteristics {
        let values = column.values.filter { !$0.isEmpty }
        guard !values.isEmpty else {
            return ColumnCharacteristics(
                values: [],
                latinRatio: 0,
                nonLatinRatio: 0,
                avgWordLength: 0,
                emptyRatio: 1.0,
                specialCharRatio: 0,
                position: position,
                multilineRatio: 0,
                uniqueValuesRatio: 0,
                wordCount: 0
            )
        }
        
        var latinCharCount = 0
        var nonLatinCharCount = 0
        var totalChars = 0
        let multilineCount = values.filter { $0.contains("\n") }.count
        let uniqueCount = Set(values).count
        
        // Подсчет среднего количества слов
        let avgWordCount = values.reduce(0.0) { sum, value in
            sum + Double(value.split(separator: " ").count)
        } / Double(values.count)
        
        for value in values {
            for scalar in value.unicodeScalars {
                totalChars += 1
                if CharacterSet.latinLetters.contains(scalar) {
                    latinCharCount += 1
                } else if !CharacterSet.whitespaces.contains(scalar) &&
                          !CharacterSet.punctuationCharacters.contains(scalar) {
                    nonLatinCharCount += 1
                }
            }
        }
        
        return ColumnCharacteristics(
            values: values,
            latinRatio: Double(latinCharCount) / Double(max(1, totalChars)),
            nonLatinRatio: Double(nonLatinCharCount) / Double(max(1, totalChars)),
            avgWordLength: column.avgLength,
            emptyRatio: column.emptyRatio,
            specialCharRatio: column.specialCharRatio,
            position: position,
            multilineRatio: Double(multilineCount) / Double(values.count),
            uniqueValuesRatio: Double(uniqueCount) / Double(values.count),
            wordCount: avgWordCount
        )
    }
    
    private func findBestTranslationPair(analyses: [ColumnCharacteristics]) -> (Int?, Int?) {
        var bestScore = -Double.infinity
        var frontIndex: Int?
        var backIndex: Int?
        
        for i in 0..<analyses.count {
            for j in 0..<analyses.count where i != j {
                let score = scoreTranslationPair(
                    potential_front: analyses[i],
                    potential_back: analyses[j]
                )
                
                if score > bestScore {
                    bestScore = score
                    frontIndex = i
                    backIndex = j
                }
            }
        }
        
        return (frontIndex, backIndex)
    }
    
    private func scoreTranslationPair(potential_front: ColumnCharacteristics, potential_back: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // 1. Разные системы письма (самый важный фактор)
        if potential_front.isMainlyLatin && potential_back.isMainlyNonLatin {
            score += 15.0
        }
        
        // 2. Похожая структура данных
        // - Похожее количество уникальных значений
        let uniquenessDiff = abs(potential_front.uniqueValuesRatio - potential_back.uniqueValuesRatio)
        score -= uniquenessDiff * 5.0
        
        // - Похожий процент пустых значений
        let emptyDiff = abs(potential_front.emptyRatio - potential_back.emptyRatio)
        score -= emptyDiff * 5.0
        
        // 3. Характеристики текста перевода
        // - Обычно это одиночные слова или короткие фразы
        if potential_front.wordCount < 3 && potential_back.wordCount < 3 {
            score += 3.0
        }
        
        // - Редко содержат переносы строк
        score -= (potential_front.multilineRatio + potential_back.multilineRatio) * 5.0
        
        // 4. Позиционный фактор (небольшой бонус если колонки рядом)
        let positionDiff = abs(potential_front.position - potential_back.position)
        score += 1.0 / Double(positionDiff + 1)
        
        return score
    }
    
    private func scoreForHint(analysis: ColumnCharacteristics) -> Double {
        var score = 0.0
        
        // Hint обычно содержит короткие фразы
        if analysis.avgWordLength < 30 {
            score += 3.0
        }
        
        // Hint может иметь повторяющиеся значения
        if analysis.uniqueValuesRatio < 0.8 {
            score += 2.0
        }
        
        // Hint редко содержит переносы строк
        score -= analysis.multilineRatio * 5.0
        
        // Hint обычно содержит одно-два слова
        if analysis.wordCount <= 2 {
            score += 2.0
        }
        
        return score
    }
}

extension CharacterSet {
    static let latinLetters: CharacterSet = {
        var chars = CharacterSet.lowercaseLetters
        chars.insert(charactersIn: "A"..."Z")
        return chars
    }()
}

// MARK: - CSV Manager
final class CSVManager {
    static let shared = CSVManager()
    private init() {}
    
    // MARK: - Public Methods
    func parse(url: URL, dictionaryItem: DictionaryItemModel? = nil) throws -> (dictionary: DictionaryItemModel, words: [WordItemModel]) {
        let tableName = generateTableName()
        
        // Create dictionary model
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
        
        // Parse words
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
    
    // MARK: - Private Methods
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
        
        // Determine if first line is header
        let startIndex = lines[0].lowercased().contains("front") ||
                        lines[0].lowercased().contains("text") ? 1 : 0
        
        // Get sample for analysis
        let sampleLines = Array(lines[startIndex..<min(startIndex + 30, lines.count)])
            .map { parseCsvLine(line: $0, separator: separator) }
        
        // Classify columns
        let classifier = ColumnClassifier(sampleData: sampleLines)
        let columnTypes = classifier.classifyColumns()
        
        guard columnTypes.contains("front_text") && columnTypes.contains("back_text") else {
            throw CSVManagerError.notEnoughColumns
        }
        
        // Parse all lines into word items
        return try parseCsvLines(
            lines: Array(lines[startIndex...]),
            columnTypes: columnTypes,
            separator: separator,
            tableName: tableName
        )
    }
}

// MARK: - Helper Functions
private func parseCsvLine(line: String, separator: String) -> [String] {
    var iterator = line.makeIterator()
    var result: [String] = []
    var insideQuotes = false
    var currentField = ""
    
    while let char = iterator.next() {
        if char == "\"" {
            if insideQuotes {
                if let nextChar = iterator.next() {
                    if nextChar == "\"" {
                        currentField.append("\"")
                    } else {
                        insideQuotes = false
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

private func parseCsvLines(lines: [String], columnTypes: [String], separator: String, tableName: String) throws -> [WordItemModel] {
    var wordItems = [WordItemModel]()
    
    for line in lines {
        let columns = parseCsvLine(line: line, separator: separator)
        guard !columns.isEmpty else { continue }
        
        var frontText: String?
        var backText: String?
        var hint: String?
        var description: String?
        
        for (index, value) in columns.enumerated() {
            guard index < columnTypes.count else { break }
            guard !value.isEmpty else { continue }
            
            switch columnTypes[index] {
            case "front_text":
                frontText = value
            case "back_text":
                backText = value
            case "hint":
                hint = value
            case "description":
                description = value
            default:
                continue
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
}

private func detectCsvSeparator(in content: String) -> String {
    let possibleSeparators = [",", ";", "\t", "|", ":", "/", "\\"]
    var separatorScores: [String: Int] = [:]
    
    let lines = content.components(separatedBy: .newlines)
        .prefix(10)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    
    for separator in possibleSeparators {
        for line in lines {
            let components = line.components(separatedBy: separator)
            if (2...4).contains(components.count) {
                separatorScores[separator, default: 0] += 1
            }
        }
    }
    
    return separatorScores.max(by: { $0.value < $1.value })?.key ?? ","
}

private func detectCsvLanguage(for text: String) -> String {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString(text)
    return recognizer.dominantLanguage?.rawValue ?? "und"
}

private func generateTableName() -> String {
    return "dict-\(UUID().uuidString.prefix(8))"
}
