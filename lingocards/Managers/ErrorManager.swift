import Foundation
import Combine

enum GlobalError: Error, LocalizedError, Identifiable {
    var id: UUID { UUID() }  // Для уникальности каждой ошибки

    // Добавляем поле `source`, чтобы отслеживать источник ошибки
    case custom(message: String, context: ErrorContext, source: ErrorSource)
    
    var errorDescription: String? {
        switch self {
        case .custom(let message, _, _):
            return message
        }
    }

    // Получение контекста ошибки
    var context: ErrorContext {
        switch self {
        case .custom(_, let context, _):
            return context
        }
    }
    
    // Получение источника ошибки
    var source: ErrorSource {
        switch self {
        case .custom(_, _, let source):
            return source
        }
    }
}


final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()  // Синглтон

    @Published var currentError: GlobalError?  // Текущее состояние ошибки
    @Published var isErrorVisible: Bool = false  // Состояние видимости ошибки
    
    private var dismissTimer: AnyCancellable?  // Таймер для автоматического удаления ошибки

    private init() {}

    // Метод для установки ошибки с указанием контекста и источника
    func setError(message: String, context: ErrorContext, source: ErrorSource, dismissAfter seconds: TimeInterval = 2.0) {
        let error = GlobalError.custom(message: message, context: context, source: source)
        setError(error, dismissAfter: seconds)
    }

    // Метод для явного задания `GlobalError` и очистки через заданное время
    func setError(_ error: GlobalError, dismissAfter seconds: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            self.currentError = error
            self.isErrorVisible = true
            self.startDismissTimer(after: seconds)  // Запускаем таймер для автоматической очистки
        }
    }

    // Метод для ручной очистки ошибки
    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.isErrorVisible = false
            self.dismissTimer?.cancel()  // Останавливаем таймер, если он активен
        }
    }

    // Метод для очистки ошибок определенного источника
    func clearError(for source: ErrorSource) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.source == source {
                self.currentError = nil
                self.isErrorVisible = false
                self.dismissTimer?.cancel()  // Останавливаем таймер, если он активен
            }
        }
    }

    // Метод для старта таймера удаления ошибки
    private func startDismissTimer(after seconds: TimeInterval) {
        // Останавливаем предыдущий таймер, если он уже был запущен
        dismissTimer?.cancel()

        // Создаем новый таймер для автоматического удаления ошибки через указанное время
        dismissTimer = Just(())
            .delay(for: .seconds(seconds), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.clearError()
            }
    }
}
