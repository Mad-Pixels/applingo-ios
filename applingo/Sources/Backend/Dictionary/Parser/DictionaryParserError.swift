import Foundation

enum DictionaryParserError: Error, LocalizedError {
    case fileReadFailed(String)
    case parsingFailed(String)
    case invalidFormat(String)
    case notEnoughColumns
    case emptyFile
    case unsupportedFormat
    
    var errorDescription: String? {
        switch self {
        case .fileReadFailed(let details):
            return "Failed to read file: \(details)"
        case .parsingFailed(let details):
            return "Parsing failed: \(details)"
        case .invalidFormat(let details):
            return "Invalid format: \(details)"
        case .notEnoughColumns:
            return "File must contain at least 2 columns (front_text, back_text)"
        case .emptyFile:
            return "File is empty"
        case .unsupportedFormat:
            return "File format is not supported"
        }
    }
}
