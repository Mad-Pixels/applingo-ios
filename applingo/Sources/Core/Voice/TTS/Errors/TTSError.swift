import Foundation

/// Errors related to TTS operations.
enum TTSError: Error {
    case emptyText
    case invalidLanguageCode(code: String)
    case voiceNotFound(language: String)
    case audioSessionError(details: String)
}

extension TTSError {
    /// Developer message (non-localized) for the error.
    var developerMessage: String {
        switch self {
        case .emptyText:
            return "The text provided for speech is empty."
        case .invalidLanguageCode(let code):
            return "Invalid language code provided: \(code)."
        case .voiceNotFound(let language):
            return "No voice found for the language: \(language)."
        case .audioSessionError(let details):
            return "Audio session error occurred: \(details)"
        }
    }
    
    /// Localized user-friendly message for the error.
    var localizedMessage: String {
        let locale = TTSErrorLocale.shared
        switch self {
        case .emptyText:
            return locale.emptyText
        case .invalidLanguageCode:
            return locale.invalidLanguageCode
        case .voiceNotFound:
            return locale.voiceNotFound
        case .audioSessionError:
            return locale.audioSessionError
        }
    }
    
    /// Localized error title.
    var localizedTitle: String {
        return TTSErrorLocale.shared.errorTitle
    }
    
    /// The severity level of the error.
    var severity: AppErrorContext.ErrorSeverity {
        switch self {
        case .audioSessionError:
            return .critical
        case .voiceNotFound, .invalidLanguageCode:
            return .error
        case .emptyText:
            return .warning
        }
    }
}
