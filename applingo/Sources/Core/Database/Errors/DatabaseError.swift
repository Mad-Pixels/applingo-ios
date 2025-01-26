import Foundation

enum DatabaseError: Error, LocalizedError {
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
            return "No active dictionaries found"
        case .invalidSearchParameters:
            return "Invalid search parameters provided"
        case .invalidWord(let details):
            return "Invalid word data: \(details)"
        case .wordNotFound(let id):
            return "Word with id \(id) not found"
        case .duplicateWord(let word):
            return "Word already exists: \(word)"
        case .updateFailed(let details):
            return "Failed to update word: \(details)"
        case .deleteFailed(let details):
            return "Failed to delete word: \(details)"
        case .alreadyConnected:
            return "Database is already connected."
        }
    }
}
