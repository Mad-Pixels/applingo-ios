import Foundation
import Combine

enum GlobalError: Error, LocalizedError, Identifiable {
    var id: UUID { UUID() }

    case appError(appError: AppError, context: ErrorContext)

    var errorDescription: String? {
        switch self {
        case .appError(let appError, _):
            return appError.localizedDescription
        }
    }

    // Получение контекста ошибки
    var context: ErrorContext {
        switch self {
        case .appError(_, let context):
            return context
        }
    }

    // Получение исходной ошибки
    var appError: AppError {
        switch self {
        case .appError(let appError, _):
            return appError
        }
    }
}

// Контекст ошибки для разделения по экранам или областям
//enum ErrorContext: String {
//    case words
//    case dictionaries
//    case settings
//    case general
//}

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()  // Синглтон

    @Published var currentError: GlobalError?  // Текущее состояние ошибки
    
    private init() {}  // Закрытый инициализатор, чтобы класс был синглтоном
    
    // Метод для установки ошибки с `AppError` и `ErrorContext`
    func setError(appError: AppError, context: ErrorContext) {
        let globalError = GlobalError.appError(appError: appError, context: context)
        setError(globalError)
        
        // Логгируем ошибку
        LogHandler.shared.sendLog(appError.toErrorLog())
    }

    // Метод для установки `GlobalError`
    func setError(_ error: GlobalError) {
        DispatchQueue.main.async {
            self.currentError = error
        }
    }

    // Метод для очистки ошибки
    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
        }
    }
}
