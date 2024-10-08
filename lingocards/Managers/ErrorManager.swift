import Foundation
import Combine

// Определение типа ошибки с контекстом
enum GlobalError: Error, LocalizedError, Identifiable {
    var id: UUID { UUID() }  // Для уникальности каждой ошибки

    case custom(message: String, context: ErrorContext)
    
    var errorDescription: String? {
        switch self {
        case .custom(let message, _):
            return message
        }
    }

    // Получение контекста ошибки
    var context: ErrorContext {
        switch self {
        case .custom(_, let context):
            return context
        }
    }
}

// Контекст ошибки для разделения по экранам или областям
enum ErrorContext: String {
    case words
    case dictionaries
    case settings
    case general
}

// Глобальный менеджер для управления ошибками
final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()  // Синглтон

    @Published var currentError: GlobalError?  // Текущее состояние ошибки
    
    private init() {}  // Закрытый инициализатор, чтобы класс был синглтоном
    
    // Метод для установки ошибки с указанием контекста
    func setError(_ error: GlobalError) {
        DispatchQueue.main.async {
            self.currentError = error
        }
    }

    // Метод для установки ошибки с параметрами
    func setError(message: String, context: ErrorContext) {
        let error = GlobalError.custom(message: message, context: context)
        setError(error)
    }

    // Метод для очистки ошибки
    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
        }
    }
}
