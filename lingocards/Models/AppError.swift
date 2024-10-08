import Foundation

/// Модель для описания ошибки в приложении
struct AppError: Codable, Identifiable {
    let id = UUID()  // Уникальный идентификатор для отслеживания ошибок
    let errorType: ErrorType
    let errorMessage: String
    let additionalInfo: [String: String]?

    /// Инициализация ошибки
    init(
        errorType: ErrorType,
        errorMessage: String,
        additionalInfo: [String: String]? = nil
    ) {
        self.errorType = errorType
        self.errorMessage = errorMessage
        self.additionalInfo = additionalInfo
    }

    /// Метод для логгирования ошибки в формате `ErrorLog`
    func toErrorLog() -> ErrorLog {
        return ErrorLog(
            errorType: errorType,
            errorMessage: errorMessage,
            additionalInfo: additionalInfo
        )
    }
    
    var localizedDescription: String {
        return "[\(errorType.rawValue)] \(errorMessage)"
    }
}

/// Контекст ошибки для разделения по экранам или областям
enum ErrorContext: String, Codable {
    case words
    case dictionaries
    case settings
    case general
}

/// Типы ошибок
enum ErrorType: String, Codable {
    case database = "database"
    case network = "network"
    case unknown = "unknown"
    case api = "api"
    case ui = "ui"
}
