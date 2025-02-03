import Foundation

/// A processor that converts a DatabaseError into an AppError.
/// It extracts the error details, severity, localized messages, and developer message from a DatabaseError instance,
/// and returns an AppError object that can be handled by the error management system.
struct DatabaseErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let dbError = error as? DatabaseError else { return nil }
        
        return AppError(
            type: .database(operation: ""),
            originalError: dbError,
            context: AppErrorContext(
                source: .database,
                screen: AppStorage.shared.activeScreen,
                metadata: ["developerMessage": dbError.developerMessage],
                severity: dbError.severity
            ),
            title: dbError.localizedTitle,
            message: dbError.localizedMessage,
            actionTitle: nil,
            action: nil
        )
    }
}
