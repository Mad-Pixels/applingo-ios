import Foundation

/// Errors related to database operations with additional parameters.
enum DatabaseError: Error {
    case connectionNotEstablished
    case emptyActiveDictionaries
    case invalidSearchParameters
    case alreadyConnected
    case selectDataFailed(details: String)
    case connectionFailed(details: String)
    case fileImportFailed(details: String)
    case migrationFailed(details: String)
    case duplicateWord(word: String)
    case updateFailed(details: String)
    case saveFailed(details: String)
    case deleteFailed(details: String)
    case invalidWord(details: String)
    case invalidOffset(offset: Int)
    case invalidLimit(limit: Int)
    case wordNotFound(id: Int)
}

extension DatabaseError {
    
    /// Developer message (non-localized) for the error.
    var developerMessage: String {
        switch self {
        case .connectionNotEstablished:
            return "Database connection is not established."
        case .emptyActiveDictionaries:
            return "No active dictionaries found."
        case .invalidSearchParameters:
            return "Invalid search parameters provided."
        case .selectDataFailed:
            return "Failed to select data from the database."
        case .alreadyConnected:
            return "Database is already connected."
        case .connectionFailed(let details):
            return "Failed to connect to the database. Details: \(details)"
        case .fileImportFailed(let details):
            return "File import failed. Details: \(details)"
        case .migrationFailed(let details):
            return "Migration failed. Details: \(details)"
        case .duplicateWord(let word):
            return "Word already exists: \(word)"
        case .updateFailed(let details):
            return "Failed to update word. Details: \(details)"
        case .saveFailed(let details):
            return "Failed to save data. Details: \(details)"
        case .deleteFailed(let details):
            return "Failed to delete word. Details: \(details)"
        case .invalidWord(let details):
            return "Invalid word data: \(details)"
        case .invalidOffset(let offset):
            return "Invalid offset value: \(offset)"
        case .invalidLimit(let limit):
            return "Invalid limit value: \(limit)"
        case .wordNotFound(let id):
            return "Word with ID \(id) not found."
        }
    }
    
    /// Localized user-friendly message for the error.
    var localizedMessage: String {
        let locale = DatabaseErrorLocale.shared
        switch self {
        case .connectionNotEstablished:
            return locale.connectionNotEstablished
        case .emptyActiveDictionaries:
            return locale.emptyActiveDictionaries
        case .selectDataFailed:
            return locale.selectDataFailed
        case .invalidSearchParameters:
            return locale.invalidSearchParameters
        case .alreadyConnected:
            return locale.alreadyConnected
        case .connectionFailed:
            return locale.connectionFailed
        case .fileImportFailed:
            return locale.fileImportFailed
        case .migrationFailed:
            return locale.migrationFailed
        case .duplicateWord:
            return locale.duplicateWord
        case .updateFailed:
            return locale.updateFailed
        case .saveFailed:
            return locale.saveFailed
        case .deleteFailed:
            return locale.deleteFailed
        case .invalidWord:
            return locale.invalidWord
        case .invalidOffset:
            return locale.invalidOffset
        case .invalidLimit:
            return locale.invalidLimit
        case .wordNotFound:
            return locale.wordNotFound
        }
    }
    
    /// Localized error title (usually common for all database errors).
    var localizedTitle: String {
        return DatabaseErrorLocale.shared.errorTitle
    }
    
    /// The severity level of the error.
    var severity: AppErrorContext.ErrorSeverity {
        switch self {
        case .connectionNotEstablished, .connectionFailed, .migrationFailed:
            return .critical
        case .fileImportFailed, .updateFailed, .deleteFailed, .selectDataFailed, .saveFailed:
            return .error
        case .emptyActiveDictionaries, .invalidSearchParameters, .alreadyConnected, .duplicateWord, .invalidWord, .invalidOffset, .invalidLimit, .wordNotFound:
            return .warning
        }
    }
}
