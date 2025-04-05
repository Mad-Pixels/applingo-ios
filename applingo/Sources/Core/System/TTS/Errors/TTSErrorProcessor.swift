import Foundation

/// A processor that converts a TTSError into an AppError.
/// It extracts the error details, severity, localized messages, and developer message from a TTSError instance,
/// and returns an AppError object that can be handled by the error management system.
struct TTSErrorProcessor: ErrorProcessor {
    func process(_ error: Error) -> AppError? {
        guard let ttsError = error as? TTSError else { return nil }
        
        return AppError(
            type: .tts,
            originalError: ttsError,
            context: AppErrorContext(
                source: .system,
                screen: AppStorage.shared.activeScreen,
                metadata: ["message": ttsError.developerMessage],
                severity: ttsError.severity
            ),
            title: ttsError.localizedTitle,
            message: ttsError.localizedMessage,
            actionTitle: nil,
            action: nil
        )
    }
}
