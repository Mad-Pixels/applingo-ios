import Foundation

enum DatabaseError: Error, LocalizedError {
    case alreadyConnected
    case connectionFailed(String)
    case migrationFailed(String)
    case connectionNotEstablished
    case csvImportFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .alreadyConnected:
            return "Database is already connected."
        case .connectionFailed(let details):
            return "Failed to connect to the database. Details: \(details)"
        case .migrationFailed(let details):
            return "Migration failed. Details: \(details)"
        case .connectionNotEstablished:
            return "Database connection is not established."
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        }
    }
}
