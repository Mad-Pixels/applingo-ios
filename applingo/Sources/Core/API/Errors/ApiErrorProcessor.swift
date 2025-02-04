import Foundation

/// A processor that converts an APIError into an AppError.
/// It extracts the error details, severity, localized messages, and developer message from an APIError instance,
/// and returns an AppError object that can be handled by the error management system.
struct APIErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let apiError = error as? APIError else { return nil }
        
        let statusCode: Int = {
            switch apiError {
            case .apiErrorMessage(_, let code):
                return code
            case .httpError(let code):
                return code
            default:
                return 0
            }
        }()
        
        return AppError(
            type: .network(statusCode: statusCode),
            originalError: apiError,
            context: AppErrorContext(
                source: .network,
                screen: AppStorage.shared.activeScreen,
                metadata: ["developerMessage": apiError.developerMessage],
                severity: apiError.severity
            ),
            title: apiError.localizedTitle,
            message: apiError.localizedMessage,
            actionTitle: nil,
            action: nil
        )
    }
}
