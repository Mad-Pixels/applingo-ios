import Foundation

/// Errors related to ASR (Automatic Speech Recognition) operations.
enum ASRError: Error {
    case audioInputUnavailable
    case recognitionFailed(details: String)
    case unsupportedLanguage(code: String)
    case authorizationDenied
    case noRecognitionResult
    case recordingSessionError(details: String)
}

extension ASRError {
    /// Developer message (non-localized) for the error.
    var developerMessage: String {
        switch self {
        case .audioInputUnavailable:
            return "The audio input device is unavailable."
        case .recognitionFailed(let details):
            return "Speech recognition failed: \(details)."
        case .unsupportedLanguage(let code):
            return "The language code is not supported for speech recognition: \(code)."
        case .authorizationDenied:
            return "Speech recognition authorization was denied by the user."
        case .noRecognitionResult:
            return "No recognition result was returned."
        case .recordingSessionError(let details):
            return "Recording session error occurred: \(details)"
        }
    }
    
    /// Localized user-friendly message for the error.
    var localizedMessage: String {
        let locale = ASRErrorLocale.shared
        switch self {
        case .audioInputUnavailable:
            return locale.audioInputUnavailable
        case .recognitionFailed:
            return locale.recognitionFailed
        case .unsupportedLanguage:
            return locale.unsupportedLanguage
        case .authorizationDenied:
            return locale.authorizationDenied
        case .noRecognitionResult:
            return locale.noRecognitionResult
        case .recordingSessionError:
            return locale.recordingSessionError
        }
    }
    
    /// Localized error title.
    var localizedTitle: String {
        return ASRErrorLocale.shared.errorTitle
    }
    
    /// The severity level of the error.
    var severity: AppErrorContext.ErrorSeverity {
        switch self {
        case .authorizationDenied, .recordingSessionError:
            return .critical
        case .recognitionFailed, .audioInputUnavailable:
            return .error
        case .unsupportedLanguage, .noRecognitionResult:
            return .warning
        }
    }
}
