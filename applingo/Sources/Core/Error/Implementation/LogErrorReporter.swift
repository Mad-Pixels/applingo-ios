import Foundation

struct LogErrorReporter: ErrorReporter {
    func report(_ error: AppError) {
        Logger.error("""
            [Error Report]
            Type: \(error.type)
            Screen: \(error.context.screen)
            Severity: \(error.context.severity)
            Source: \(error.context.source)
            Message: \(error.message)
            Metadata: \(error.context.metadata)
            """,
            type: .api
        )
    }
}
