import NaturalLanguage
import Foundation

func parseCsvLines(lines: [String], columnTypes: [String], separator: String, tableName: String) throws -> [WordItemModel] {
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

func parseCsvLine(line: String, separator: String) -> [String] {
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

func detectCsvSeparator(in content: String) -> String {
    let possibleSeparators = [",", ";", "\t", "|", ":", "/", "\\"]
    
    let lines = content.components(separatedBy: .newlines)
        .prefix(10)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }
    
    var separatorScores: [String: Int] = [:]
    
    for separator in possibleSeparators {
        for line in lines {
            let components = line.components(separatedBy: separator)
            if (2...4).contains(components.count) {
                separatorScores[separator, default: 0] += 1
            }
        }
    }
    if let (bestSeparator, _) = separatorScores.max(by: { $0.value < $1.value }) {
        return bestSeparator
    }
    return ","
}

func detectCsvLanguage(for text: String) -> String {
    let recognizer = NLLanguageRecognizer()
    recognizer.processString(text)
    
    if let language = recognizer.dominantLanguage?.rawValue {
        // Список языков, которые знает модель
        let knownLanguages: Set<String> = [
            "de", "en", "es", "fr", "he",
            "it", "ja", "ko", "mul", "ru",
            "und", "zh"
        ]
        
        // Если язык известен модели - возвращаем его, иначе und
        return knownLanguages.contains(language) ? language : "und"
    }
    
    return "und"
}

func generateTableName() -> String {
    return "dict-\(UUID().uuidString.prefix(8))"
}
