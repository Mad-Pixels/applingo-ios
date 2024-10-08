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

    var context: ErrorContext {
        switch self {
        case .appError(_, let context):
            return context
        }
    }

    var appError: AppError {
        switch self {
        case .appError(let appError, _):
            return appError
        }
    }
}

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()  // Синглтон

    @Published var currentError: GlobalError?  // Текущее состояние ошибки
    @Published var isErrorVisible: Bool = false  // Состояние видимости ошибки
    
    private init() {}  // Закрытый инициализатор, чтобы класс был синглтоном
    
    func setError(appError: AppError, context: ErrorContext) {
        let globalError = GlobalError.appError(appError: appError, context: context)
        setError(globalError)
        
        // Показываем ошибку
        isErrorVisible = true
        
        // Логгируем ошибку
        LogHandler.shared.sendLog(appError.toErrorLog())
    }

    func setError(_ error: GlobalError) {
        DispatchQueue.main.async {
            self.currentError = error
            self.isErrorVisible = true
        }
    }

    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.isErrorVisible = false
        }
    }
}

