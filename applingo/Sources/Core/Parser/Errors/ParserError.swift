import Foundation

/// Enum describing various errors that can occur during table parsing.
public enum ParserError: Error, LocalizedError {
    case fileReadFailed(String)
    case parsingFailed(String)
    case invalidFormat(String)
    case notEnoughColumns
    case emptyFile
    case unsupportedFormat

    /// Developer message (non-localized) for the error.
    public var developerMessage: String {
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

    /// Localized user-friendly message for the error.
    public var localizedMessage: String {
        return ParserErrorLocale.shared.localizedMessage(for: self)
    }

    /// Localized error title (usually common for all parser errors).
    public var localizedTitle: String {
        return ParserErrorLocale.shared.errorTitle
    }
    
    public var errorDescription: String? {
        return developerMessage
    }
}
