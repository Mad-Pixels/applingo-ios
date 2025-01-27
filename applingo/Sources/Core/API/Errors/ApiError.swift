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
            
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
            
        case .s3Error(let message):
            return "Failed to download dictionary: \(message)"
            
        case .emptyDictionary:
            return "Dictionary is empty or contains no valid words"
            
        case .invalidCSVFormat(let message):
            return "Invalid CSV format: \(message)"
        }
    }
}
