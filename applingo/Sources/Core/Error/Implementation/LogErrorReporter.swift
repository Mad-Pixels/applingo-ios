import Foundation

struct LogErrorReporter: ErrorReporter {
    func report(_ error: AppError) {
        // Используем Logger.error и передаём AppError
        Logger.error("""
            [Error Report]
            Type: \(error.type)
            Screen: \(error.context.screen)
            Severity: \(error.context.severity)
            Source: \(error.context.source)
            Message: \(error.message)
            Metadata: \(error.context.metadata)
            """,
            appError: error, // Передаём AppError в логгер
            metadata: error.context.metadata // Дополнительно добавляем метаданные
        )
    }
}
