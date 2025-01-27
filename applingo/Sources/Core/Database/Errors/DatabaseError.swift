import Foundation

/// An enum representing database-related errors with user-friendly descriptions.
enum DatabaseError: Error, LocalizedError {
    // MARK: - Error Cases
    
    case connectionNotEstablished
    case emptyActiveDictionaries
    case invalidSearchParameters
    case alreadyConnected
    case connectionFailed(String)
    case csvImportFailed(String)
    case migrationFailed(String)
    case duplicateWord(String)
    case updateFailed(String)
    case deleteFailed(String)
    case invalidWord(String)
    case invalidOffset(Int)
    case invalidLimit(Int)
    case wordNotFound(Int)
    
    // MARK: - LocalizedError Conformance
    
    /// Provides a user-friendly description of the error.
    var errorDescription: String? {
        switch self {
        case .connectionFailed(let details):
            return "Failed to connect to the database. Details: \(details)"
        case .migrationFailed(let details):
            return "Migration failed. Details: \(details)"
        case .connectionNotEstablished:
            return "Database connection is not established."
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        case .invalidLimit(let limit):
            return "Invalid limit value: \(limit)"
        case .invalidOffset(let offset):
            return "Invalid offset value: \(offset)"
        case .emptyActiveDictionaries:
            return "No active dictionaries found."
        case .invalidSearchParameters:
            return "Invalid search parameters provided."
        case .invalidWord(let details):
            return "Invalid word data: \(details)"
        case .wordNotFound(let id):
            return "Word with ID \(id) not found."
        case .duplicateWord(let word):
            return "Word already exists: \(word)"
        case .updateFailed(let details):
            return "Failed to update word. Details: \(details)"
        case .deleteFailed(let details):
            return "Failed to delete word. Details: \(details)"
        case .alreadyConnected:
            return "Database is already connected."
        }
    }
}
