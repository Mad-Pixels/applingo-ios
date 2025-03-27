import Foundation
import CoreXLSX

/// Parser for processing Excel files (.xlsx)
public final class ParserExcel: AbstractParser {
    
    private let format: ParserModelFormat
    
    /// Initializes the Excel parser with a given format.
    /// - Parameter format: The table format.
    public init(format: ParserModelFormat = .excel) {
        self.format = format
    }
    
    /// Checks whether the file is an Excel file based on its extension.
    /// - Parameter fileExtension: The file extension.
    /// - Returns: `true` if the extension indicates an Excel file.
    public func canHandle(fileExtension: String) -> Bool {
        let ext = fileExtension.lowercased()
        return ext == "xlsx" || ext.hasSuffix(".xlsx")
    }
    
    /// Parses an Excel file from the specified URL.
    /// - Parameters:
    ///   - url: The URL to the Excel file.
    ///   - encoding: The encoding (not used for Excel, but required by the protocol).
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError` if the file is empty or has an invalid format.
    public func parse(url: URL, encoding: String.Encoding = .utf8) throws -> [ParserModelWord] {
        Logger.debug(
            "[Parser]: Starting to parse Excel",
            metadata: [
                "url": "\(url)"
            ]
        )
        
        guard let file = XLSXFile(filepath: url.path) else {
            Logger.debug("[Parser]: Failed to open Excel file")
            throw ParserError.fileReadFailed("Could not read Excel file at \(url)")
        }
        
        return try parseExcel(file)
    }
    
    /// Parses Excel data, extracting words.
    /// - Parameter file: The opened Excel file.
    /// - Returns: An array of `ParserModelWord`.
    /// - Throws: `ParserError` if the file has an unexpected structure.
    private func parseExcel(_ file: XLSXFile) throws -> [ParserModelWord] {
        // Get list of worksheet paths.
        let worksheetPaths: [String]
        do {
            worksheetPaths = try file.parseWorksheetPaths()
        } catch {
            Logger.debug("[Parser]: No worksheets found in Excel file")
            throw ParserError.invalidFormat("No worksheets found in Excel file")
        }
        
        // Use the first sheet.
        guard let firstSheetPath = worksheetPaths.first else {
            Logger.debug("[Parser]: Empty Excel file with no sheets")
            throw ParserError.emptyFile
        }
        
        let worksheet: Worksheet
        do {
            worksheet = try file.parseWorksheet(at: firstSheetPath)
        } catch {
            Logger.debug("[Parser]: Failed to parse worksheet")
            throw ParserError.parsingFailed("Failed to parse worksheet")
        }
        
        let sharedStrings: SharedStrings?
        do {
            sharedStrings = try file.parseSharedStrings()
        } catch {
            sharedStrings = nil
            Logger.debug("[Parser]: No shared strings in Excel file, continuing anyway")
        }
        
        var words = [ParserModelWord]()
        
        let rows = worksheet.data?.rows ?? []
        for row in rows {
            let cellValues = self.getCellValues(cells: row.cells, sharedStrings: sharedStrings)
            Logger.debug(
                "[Parser]: Found columns in row",
                metadata: [
                    "row_reference": "\(row.reference)",
                    "columns_count": "\(cellValues.count)"
                ]
            )
            
            guard cellValues.count >= 2 else {
                Logger.debug(
                    "[Parser]: Skipping row due to insufficient columns",
                    metadata: [
                        "row_reference": "\(row.reference)"
                    ]
                )
                continue
            }
            
            if cellValues[0].isEmpty || cellValues[1].isEmpty {
                Logger.debug(
                    "[Parser]: Skipping row due to empty front/back text",
                    metadata: [
                        "row_reference": "\(row.reference)"
                    ]
                )
                continue
            }
            
            let word = ParserModelWord(
                dictionary: UUID().uuidString,
                frontText: cellValues[0],
                backText: cellValues[1],
                description: cellValues.count > 3 ? cellValues[3] : "",
                hint: cellValues.count > 2 ? cellValues[2] : ""
            )
            words.append(word)
        }
        
        guard !words.isEmpty else {
            throw ParserError.parsingFailed("No valid word entries found in Excel file")
        }
        
        Logger.debug(
            "[Parser]: Successfully parsed Excel words",
            metadata: [
                "words_count": "\(words.count)"
            ]
        )
        return words
    }
    
    /// Extracts cell values from a row.
    /// - Parameters:
    ///   - cells: The Excel row cells.
    ///   - sharedStrings: The shared strings from the file.
    /// - Returns: An array of cell values as strings.
    private func getCellValues(cells: [Cell], sharedStrings: SharedStrings?) -> [String] {
        var cellValues = [String]()
        
        for cell in cells {
            let value = getStringValue(from: cell, sharedStrings: sharedStrings)
            cellValues.append(value)
        }
        return cellValues
    }
    
    /// Extracts a string value from a cell.
    /// - Parameters:
    ///   - cell: An Excel cell.
    ///   - sharedStrings: The shared strings from the file.
    /// - Returns: The string value.
    private func getStringValue(from cell: Cell, sharedStrings: SharedStrings?) -> String {
        if let sharedStrings = sharedStrings, cell.type == .sharedString {
            if let value = cell.value, let stringIndex = Int(value), stringIndex < sharedStrings.items.count {
                if let text = sharedStrings.items[stringIndex].text {
                    return text
                }
            }
        }
        
        if let value = cell.value {
            return value
        }
        return ""
    }
}
