import Foundation

final class DelimitedTextParser: DictionaryParserProtocol {
    private let format: TableFormat
    
    init(format: TableFormat) {
        self.format = format
    }
    
    func canHandle(fileExtension: String) -> Bool {
        let ext = fileExtension.lowercased()
                return ext == "csv" || ext.hasSuffix(".csv")
    }
    
    func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [DatabaseModelWord] {
        Logger.debug("[DelimitedTextParser] Starting to parse file: \(url.lastPathComponent)")
        
        let content = try String(contentsOf: url, encoding: encoding)
        Logger.debug("[DelimitedTextParser] File content length: \(content.count)")
        
        let lines = content.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        Logger.debug("[DelimitedTextParser] Found \(lines.count) non-empty lines")
        
        guard !lines.isEmpty else {
            Logger.error("[DelimitedTextParser] File is empty")
            throw DictionaryParserError.emptyFile
        }
        
        let dataLines = format.hasHeader ? Array(lines.dropFirst()) : lines
        Logger.debug("[DelimitedTextParser] Processing \(dataLines.count) data lines")
        
        return try parseLines(dataLines)
    }
    
    private func parseLines(_ lines: [String]) throws -> [DatabaseModelWord] {
        var words = [DatabaseModelWord]()
        
        for (index, line) in lines.enumerated() {
            let columns = parseLine(line)
            Logger.debug("[DelimitedTextParser] Line \(index): Found \(columns.count) columns")
            
            guard columns.count >= 2 else {
                Logger.debug("[DelimitedTextParser] Skipping line \(index): not enough columns")
                continue
            }
            
            do {
                let word = try createWord(from: columns)
                words.append(word)
            } catch {
                Logger.error("[DelimitedTextParser] Error creating word from line \(index): \(error)")
                throw error
            }
        }
        
        guard !words.isEmpty else {
            Logger.error("[DelimitedTextParser] No valid words found")
            throw DictionaryParserError.parsingFailed("No valid word pairs found")
        }
        
        Logger.debug("[DelimitedTextParser] Successfully parsed \(words.count) words")
        return words
    }
    
    private func parseLine(_ line: String) -> [String] {
        var result = [String]()
        var currentField = ""
        var insideQuotes = false
        var iterator = line.makeIterator()
        
        while let char = iterator.next() {
            if char == format.quoteCharacter {
                if insideQuotes {
                    if let nextChar = iterator.next() {
                        if nextChar == format.quoteCharacter {
                            currentField.append(String(format.quoteCharacter))
                        } else {
                            insideQuotes = false
                            if String(nextChar) != format.separator {
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
            } else if String(char) == format.separator && !insideQuotes {
                result.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
        }
        
        result.append(currentField)
        return result
    }
    
    private func createWord(from columns: [String]) throws -> DatabaseModelWord {
        guard !columns[0].isEmpty && !columns[1].isEmpty else {
            throw DictionaryParserError.invalidFormat("Empty front or back text")
        }
        
        return DatabaseModelWord(
            dictionary: UUID().uuidString,
            frontText: columns[0],
            backText: columns[1],
            description: columns.count > 3 ? columns[3] : "",
            hint: columns.count > 2 ? columns[2] : ""
        )
    }
}
