import Foundation

enum ErrorContext: String, Codable {
    case words
    case dictionaries
    case settings
    case general
}

enum ErrorType: String, Codable {
    case database = "database"
    case network = "network"
    case unknown = "unknown"
    case api = "api"
    case ui = "ui"
}

enum ErrorSource: String {
    case getWords
    case fetchData
    case saveWord
    case unknown
    case deleteWord
}

struct AppError: Error, LocalizedError, Equatable, Identifiable {
    var id: UUID { UUID() }
    let errorType: ErrorType
    let errorMessage: String
    let additionalInfo: [String: String]?

    var errorDescription: String? {
        errorMessage
    }
    
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        return lhs.errorMessage == rhs.errorMessage && lhs.errorType == rhs.errorType && lhs.additionalInfo == rhs.additionalInfo
    }
}
