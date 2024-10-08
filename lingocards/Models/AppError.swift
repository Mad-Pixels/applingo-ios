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

struct AppError: Codable, Identifiable {
    var id = UUID()
    
    let errorType: ErrorType
    let errorMessage: String
    let additionalInfo: [String: String]?

    init(
        errorType: ErrorType,
        errorMessage: String,
        additionalInfo: [String: String]? = nil
    ) {
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.additionalInfo = additionalInfo
    }

    func toErrorLog() -> ErrorLog {
        return ErrorLog(
            errorType: errorType,
            errorMessage: errorMessage,
            additionalInfo: additionalInfo
        )
    }
    
    var localizedDescription: String {
        return errorMessage
    }
}
