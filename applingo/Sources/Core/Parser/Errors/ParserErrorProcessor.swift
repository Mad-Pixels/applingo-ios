import Foundation

/// A processor that converts a ParserError into an AppError.
/// It extracts error details, localized messages, and developer message from a ParserError instance,
/// returning an AppError object that can be handled by the error management system.
struct ParserErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let parserError = error as? ParserError else { return nil }
        
        return AppError(
            type: .parser,
            originalError: parserError,
            context: AppErrorContext(
                source: .parser,
                screen: AppStorage.shared.activeScreen,
                metadata: ["message": parserError.developerMessage],
                severity: .error
            ),
            title: parserError.localizedTitle,
            message: parserError.localizedMessage,
            actionTitle: nil,
            action: nil
        )
    }
}

