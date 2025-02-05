import Foundation

/// A parser that handles CSV files using a defined `TableFormat`.
public final class ParseCSV: AbstractParser {
    
    private let format: ParserModelFormat
    
    /// Initializes the CSV parser with the given `TableFormat`.
    /// - Parameter format: The table format (separator, quote, etc.).
    public init(format: ParserModelFormat = .csv) {
        self.format = format
    }
    
    /// Checks if the file has an extension `.csv`.
    /// - Parameter fileExtension: The file extension (e.g. "csv", "CSV", etc.).
    /// - Returns: `true` if the file extension indicates a CSV file.
    public func canHandle(fileExtension: String) -> Bool {
        let ext = fileExtension.lowercased()
        return ext == "csv" || ext.hasSuffix(".csv")
    }
    
    /// Parses a CSV file from the given URL.
    /// - Parameters:
    ///   - url: The URL to the CSV file.
    ///   - encoding: The encoding to use (default is `.utf8`).
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError` if the file is empty or has invalid columns.
    public func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [ParserModelWord] {
        Logger.debug("[Parser]: Starting to parse CSV", metadata: [
            "url": "\(url)",
            "encoding": "\(encoding)"
        ])
        
        ///TODO: FOR TEST ERROR
        let l = URL(fileURLWithPath: "/path/to/your/file.txt")
        
        let content: String
        do {
            //content = try String(contentsOf: l, encoding: encoding)
            content = try String(contentsOf: url, encoding: encoding)
        } catch {
            Logger.debug(
                "[Parser]: Failed to read file content",
                metadata: [
                    "error": "\(error)"
                ]
            )
            throw ParserError.fileReadFailed("Could not read file at \(url)")
        }
        
        let lines = content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        Logger.debug(
            "[Parser]: Number of non-empty lines",
            metadata: [
                "count": "\(lines.count)"
            ]
        )
        
        guard !lines.isEmpty else {
            Logger.debug("[Parser]: File is empty")
            throw ParserError.emptyFile
        }
        
        let dataLines = format.hasHeader ? Array(lines.dropFirst()) : lines
        Logger.debug(
            "[Parser]: Number of data lines (after header drop)",
            metadata: [
                "count": "\(dataLines.count)"
            ]
        )
        
        let words = try parseLines(dataLines)
        Logger.debug(
            "[Parser]: Successfully parsed CSV lines",
            metadata: [
                "words_count": "\(words.count)"
            ]
        )
        
        return words
    }
    
    /// Parses individual lines from the CSV file.
    /// - Parameter lines: An array of strings representing file lines.
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError.parsingFailed` if no valid words are found.
    private func parseLines(_ lines: [String]) throws -> [ParserModelWord] {
        var words = [ParserModelWord]()
        
        for (index, line) in lines.enumerated() {
            let columns = parseLine(line)
            Logger.debug(
                "[Parser]: Found columns in line",
                metadata: [
                    "line_index": "\(index)",
                    "columns_count": "\(columns.count)"
                ]
            )
            
            guard columns.count >= 2 else {
                Logger.debug(
                    "[Parser]: Skipping line due to insufficient columns",
                    metadata: [
                        "line_index": "\(index)"
                    ]
                )
                continue
            }
            
            if columns[0].isEmpty || columns[1].isEmpty {
                Logger.debug(
                    "[Parser]: Skipping line due to empty front/back text",
                    metadata: [
                        "line_index": "\(index)"
                    ]
                )
                continue
            }
            
            let word = ParserModelWord(
                dictionary: UUID().uuidString,
                frontText: columns[0],
                backText: columns[1],
                description: columns.count > 3 ? columns[3] : "",
                hint: columns.count > 2 ? columns[2] : ""
            )
            words.append(word)
        }
        
        guard !words.isEmpty else {
            Logger.debug("[Parser]: No valid words found after skipping invalid lines")
            throw ParserError.parsingFailed("No valid word entries found in CSV file")
        }
        return words
    }
    
//    /// Splits a single CSV line into columns, respecting quote rules.
//    /// - Parameter line: The line to parse.
//    /// - Returns: An array of column values.
//    private func parseLine(_ line: String) -> [String] {
//        var result = [String]()
//        var currentField = ""
//        var insideQuotes = false
//        var iterator = line.makeIterator()
//        
//        while let char = iterator.next() {
//            if char == format.quoteCharacter {
//                if insideQuotes {
//                    // Look ahead to see if next is another quote (escape) or separator.
//                    if let nextChar = iterator.next() {
//                        if nextChar == format.quoteCharacter {
//                            // Escaped quote
//                            currentField.append(String(format.quoteCharacter))
//                        } else {
//                            // End quote
//                            insideQuotes = false
//                            if String(nextChar) != format.separator {
//                                currentField.append(nextChar)
//                            } else {
//                                result.append(currentField)
//                                currentField = ""
//                            }
//                        }
//                    } else {
//                        // No more characters, close quotes
//                        insideQuotes = false
//                    }
//                } else {
//                    // Start quotes
//                    insideQuotes = true
//                }
//            } else if String(char) == format.separator && !insideQuotes {
//                // We've hit a separator outside quotes
//                result.append(currentField)
//                currentField = ""
//            } else {
//                currentField.append(char)
//            }
//        }
//        
//        result.append(currentField)
//        return result
//    }
    
    /// Splits a CSV line into columns while properly handling quoted fields.
    /// - Parameter line: The CSV line to parse.
    /// - Returns: An array of column values.
    private func parseLine(_ line: String) -> [String] {
        var result = [String]()
        var currentField = ""
        var insideQuotes = false
        let separator = format.separator.first!
        
        let characters = Array(line)
        var i = 0
        while i < characters.count {
            let char = characters[i]
            if char == format.quoteCharacter {
                if insideQuotes {
                    if i + 1 < characters.count && characters[i + 1] == format.quoteCharacter {
                        currentField.append(format.quoteCharacter)
                        i += 1
                    } else {
                        insideQuotes = false
                    }
                } else {
                    insideQuotes = true
                }
            } else if char == separator && !insideQuotes {
                result.append(currentField)
                currentField = ""
            } else {
                currentField.append(char)
            }
            i += 1
        }
        
        result.append(currentField)
        return result
    }
    
    /// Creates a `ParserModelWord` from an array of columns.
    /// - Parameter columns: The array of columns from one line.
    /// - Returns: A valid `ParserModelWord`.
    /// - Throws: `ParserError.invalidFormat` if frontText or backText is empty.
    private func createWord(from columns: [String]) throws -> ParserModelWord {
        guard !columns[0].isEmpty, !columns[1].isEmpty else {
            throw ParserError.invalidFormat("Empty front or back text in CSV")
        }
        
        return ParserModelWord(
            dictionary: UUID().uuidString,
            frontText: columns[0],
            backText: columns[1],
            description: columns.count > 3 ? columns[3] : "",
            hint: columns.count > 2 ? columns[2] : ""
        )
    }
}
