import NaturalLanguage
import Foundation

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

func parseCsvLines(
    lines: [String],
    separator: String,
    tableName: String
) throws -> [DatabaseModelWord] {
    var wordItems = [DatabaseModelWord]()
    
    for line in lines {
        let columns = parseCsvLine(line: line, separator: separator)
        guard columns.count >= 2 else { continue }
        
        let frontText = columns[0]
        let backText = columns[1]
        let hint = columns.count > 2 ? columns[2] : nil
        let description = columns.count > 3 ? columns[3] : nil
        
        guard !frontText.isEmpty && !backText.isEmpty else { continue }
        let wordItem = DatabaseModelWord(
            tableName: tableName,
            frontText: frontText,
            backText: backText,
            description: description,
            hint: hint
        )
        wordItems.append(wordItem)
    }
    guard !wordItems.isEmpty else {
        throw CSVManagerError.csvImportFailed("No valid word pairs found in CSV")
    }
    return wordItems
}

func detectCsvSeparator(in content: String) -> String {
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
