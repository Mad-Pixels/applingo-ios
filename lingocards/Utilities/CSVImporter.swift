import Foundation

struct CSVImporter {
    static func parseCSV(at url: URL, tableName: String) throws -> [WordItem] {
        var wordItems = [WordItem]()
        
        let content = try String(contentsOf: url, encoding: .utf8)
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedLine.isEmpty else {
                continue
            }
            
            let columns = parseCSVLine(line: trimmedLine)
            guard columns.count >= 2 else {
                continue
            }
            
            let frontText = columns[0]
            let backText = columns[1]
            let hint = columns.count > 2 ? columns[2] : nil
            let description = columns.count > 3 ? columns[3] : nil
            
            let wordItem = WordItem(
                tableName: tableName,
                frontText: frontText,
                backText: backText,
                description: description,
                hint: hint
            )
            wordItems.append(wordItem)
        }
        
        return wordItems
    }
    
    static func parseCSVLine(line: String) -> [String] {
        var result: [String] = []
        var currentField = ""
        var insideQuotes = false
        var iterator = line.makeIterator()
        
        while let char = iterator.next() {
            if char == "\"" {
                if insideQuotes, let nextChar = iterator.next() {
                    if nextChar == "\"" {
                        currentField.append("\"")
                    } else {
                        insideQuotes.toggle()
                        if nextChar != "," {
                            currentField.append(nextChar)
                        } else {
                            result.append(currentField)
                            currentField = ""
                        }
                    }
                } else {
                    insideQuotes.toggle()
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
