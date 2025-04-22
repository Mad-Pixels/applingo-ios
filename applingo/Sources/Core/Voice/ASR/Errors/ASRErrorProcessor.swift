import Foundation

/// A processor that converts an ASRError into an AppError.
/// It extracts the error details, severity, localized messages, and developer message from an ASRError instance,
/// and returns an AppError object that can be handled by the error management system.
struct ASRErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let asrError = error as? ASRError else { return nil }
        
        return AppError(
            type: .asr,
            originalError: asrError,
            context: AppErrorContext(
                source: .system,
                screen: AppStorage.shared.activeScreen,
                metadata: ["message": asrError.developerMessage],
                severity: asrError.severity
            ),
            title: asrError.localizedTitle,
            message: asrError.localizedMessage,
            actionTitle: nil,
            action: nil
        )
    }
}
