import Foundation

/// Represents errors that can occur during API operations.
enum APIError: Error, LocalizedError {
    /// API returned an error message and status code.
    case apiErrorMessage(message: String, statusCode: Int)
    
    /// The provided endpoint URL is invalid.
    case invalidEndpointURL(endpoint: String)
    
    /// The provided CSV file format is invalid.
    case invalidCSVFormat(message: String)
    
    /// The provided base URL is invalid.
    case invalidBaseURL(url: String)
    
    /// Error occurred while interacting with S3.
    case s3Error(message: String)
    
    /// HTTP error occurred with a specific status code.
    case httpError(status: Int)
    
    /// The API base URL is not configured.
    case baseURLNotConfigured
    
    /// The API response is invalid.
    case invalidAPIResponse
    
    /// The dictionary is empty or contains no valid words.
    case emptyDictionary

    /// Provides a human-readable description of the error.
    var errorDescription: String? {
        switch self {
        case .baseURLNotConfigured:
            return "API base URL is not configured"
        case .invalidBaseURL(let url):
            return "Invalid base URL: \(url)"
        case .invalidEndpointURL(let endpoint):
            return "Invalid endpoint URL: \(endpoint)"
        case .invalidAPIResponse:
            return "Invalid API response"
        case .apiErrorMessage(let message, let statusCode):
            return "API error (\(statusCode)): \(message)"
        case .httpError(let status):
            return "HTTP error: \(status)"
        case .s3Error(let message):
            return "Failed to download dictionary: \(message)"
        case .emptyDictionary:
            return "Dictionary is empty or contains no valid words"
        case .invalidCSVFormat(let message):
            return "Invalid CSV format: \(message)"
        }
    }
}

extension APIError {
    /// Developer message (non-localized) for the API error.
    var developerMessage: String {
        switch self {
        case .baseURLNotConfigured:
            return "API base URL is not configured."
        case .invalidBaseURL(let url):
            return "Invalid base URL: \(url)"
        case .invalidEndpointURL(let endpoint):
            return "Invalid endpoint URL: \(endpoint)"
        case .invalidAPIResponse:
            return "Invalid API response."
        case .apiErrorMessage(let message, let statusCode):
            return "API error (\(statusCode)): \(message)"
        case .httpError(let status):
            return "HTTP error: \(status)"
        case .s3Error(let message):
            return "Failed to download dictionary: \(message)"
        case .emptyDictionary:
            return "Dictionary is empty or contains no valid words."
        case .invalidCSVFormat(let message):
            return "Invalid CSV format: \(message)"
        }
    }
    
    /// Localized message for the API error.
    var localizedMessage: String {
        let locale = APIErrorLocale.shared
        switch self {
        case .baseURLNotConfigured:
            return locale.baseURLNotConfigured
        case .invalidBaseURL:
            return locale.invalidBaseURL
        case .invalidEndpointURL:
            return locale.invalidEndpointURL
        case .invalidAPIResponse:
            return locale.invalidAPIResponse
        case .apiErrorMessage:
            return locale.apiErrorMessage
        case .httpError:
            return locale.httpError
        case .s3Error:
            return locale.s3Error
        case .emptyDictionary:
            return locale.emptyDictionary
        case .invalidCSVFormat:
            return locale.invalidCSVFormat
        }
    }
    
    /// Localized error title (usually common for all API errors).
    var localizedTitle: String {
        return APIErrorLocale.shared.errorTitle
    }
    
    /// The severity level of the API error.
    var severity: AppErrorContext.ErrorSeverity {
        switch self {
        case .baseURLNotConfigured, .invalidBaseURL, .invalidEndpointURL, .invalidAPIResponse:
            return .critical
        case .apiErrorMessage, .httpError, .s3Error, .invalidCSVFormat:
            return .error
        case .emptyDictionary:
            return .warning
        }
    }
}
