import Foundation

struct AlertErrorHandler: ErrorHandler {
    func handle(_ error: AppError) {
        // Логируем обработку ошибки
        Logger.debug("""
            [AlertErrorHandler]
            Processing error:
            Title: \(error.title)
            Message: \(error.message)
            """
        )
        
        // Здесь может быть дополнительная логика обработки ошибки
        // Например, сохранение в локальную БД, специфичные действия и т.д.
        
        // Можно добавить специфичную логику для разных типов ошибок
        switch error.type {
        case .network(let statusCode):
            handleNetworkError(statusCode: statusCode)
        case .validation(let field):
            handleValidationError(field: field)
        default:
            break
        }
    }
    
    private func handleNetworkError(statusCode: Int) {
        // Специфичная логика для сетевых ошибок
        if statusCode == 401 {
            // Например, можем вызвать обновление токена
            Logger.debug("Handle 401 error - token refresh required")
        }
    }
    
    private func handleValidationError(field: String) {
        // Специфичная логика для ошибок валидации
        Logger.debug("Handle validation error for field: \(field)")
    }
}
