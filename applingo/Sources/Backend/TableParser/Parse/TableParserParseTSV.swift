import Foundation

/// A parser that handles TSV files using a defined `TableFormat`.
public final class TableParserParseTSV: AbstractTableParser {
    
    private let format: TableParserModelFormat
    
    /// Initializes the TSV parser with the given `TableFormat`.
    /// - Parameter format: The table format (separator, quote, etc.).
    public init(format: TableParserModelFormat = .tsv) {
        self.format = format
    }
    
    /// Checks if the file has an extension `.tsv`.
    /// - Parameter fileExtension: The file extension (e.g. "tsv", "TSV", etc.).
    /// - Returns: `true` if the file extension indicates a TSV file.
    public func canHandle(fileExtension: String) -> Bool {
        let ext = fileExtension.lowercased()
        return ext == "tsv" || ext.hasSuffix(".tsv")
    }
    
    /// Parses a TSV file from the given URL.
    /// - Parameters:
    ///   - url: The URL to the TSV file.
    ///   - encoding: The encoding to use (default is `.utf8`).
    /// - Returns: An array of `TableParserModelWord`.
    /// - Throws: `TableParserError` if the file is empty or has invalid columns.
    public func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [TableParserModelWord] {
        Logger.debug("[Parser]: Starting to parse TSV", metadata: [
            "url": "\(url)",
            "encoding": "\(encoding)"
        ])
        
        let content: String
        do {
            content = try String(contentsOf: url, encoding: encoding)
        } catch {
            Logger.debug("[Parser]: Failed to read file content", metadata: [
                "error": "\(error)"
            ])
            throw TableParserError.fileReadFailed("Could not read file at \(url)")
        }
        
        let lines = content
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        
        Logger.debug("[Parser]: Number of non-empty lines", metadata: [
            "count": "\(lines.count)"
        ])
        
        guard !lines.isEmpty else {
            Logger.debug("[Parser]: File is empty")
            throw TableParserError.emptyFile
        }
        
        let dataLines = format.hasHeader ? Array(lines.dropFirst()) : lines
        
        Logger.debug("[Parser]: Number of data lines (after header drop)", metadata: [
            "count": "\(dataLines.count)"
        ])
        
        let words = try parseLines(dataLines)
        
        Logger.debug("[Parser]: Successfully parsed TSV lines", metadata: [
            "words_count": "\(words.count)"
        ])
        
        return words
    }
    
    /// Parses individual lines from the TSV file.
    /// - Parameter lines: An array of strings representing file lines.
    /// - Returns: An array of `TableParserModelWord`.
    /// - Throws: `TableParserError.parsingFailed` if no valid words are found.
    private func parseLines(_ lines: [String]) throws -> [TableParserModelWord] {
        var words = [TableParserModelWord]()
        
        for (index, line) in lines.enumerated() {
            let columns = line.components(separatedBy: format.separator)
            
            Logger.debug("[Parser]: Found columns in line", metadata: [
                "line_index": "\(index)",
                "columns_count": "\(columns.count)"
            ])
            
            guard columns.count >= 2 else {
                Logger.debug("[Parser]: Skipping line due to insufficient columns", metadata: [
                    "line_index": "\(index)"
                ])
                continue
            }
            
            if columns[0].isEmpty || columns[1].isEmpty {
                Logger.debug("[Parser]: Skipping line due to empty front/back text", metadata: [
                    "line_index": "\(index)"
                ])
                continue
            }
            
            let word = TableParserModelWord(
                dictionary: UUID().uuidString,
                frontText: columns[0],
                backText: columns[1],
                description: columns.count > 3 ? columns[3] : "",
                hint: columns.count > 2 ? columns[2] : ""
            )
            words.append(word)
        }
        
        guard !words.isEmpty else {
            Logger.debug("[Parser]: No valid words found after parsing")
            throw TableParserError.parsingFailed("No valid word entries found in TSV file")
        }
        
        return words
    }
    
    /// Creates a `TableParserModelWord` from an array of columns.
    /// - Parameter columns: The array of columns from one line.
    /// - Returns: A valid `TableParserModelWord`.
    /// - Throws: `TableParserError.invalidFormat` if frontText or backText is empty.
    private func createWord(from columns: [String]) throws -> TableParserModelWord {
        guard !columns[0].isEmpty, !columns[1].isEmpty else {
            throw TableParserError.invalidFormat("Empty front or back text in TSV")
        }
        
        return TableParserModelWord(
            dictionary: UUID().uuidString, // Will be replaced later.
            frontText: columns[0],
            backText: columns[1],
            description: columns.count > 3 ? columns[3] : "",
            hint: columns.count > 2 ? columns[2] : ""
        )
    }
}
