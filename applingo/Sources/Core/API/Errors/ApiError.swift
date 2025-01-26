import Foundation

enum APIError: Error, LocalizedError {
    case apiErrorMessage(message: String, statusCode: Int)
    case invalidEndpointURL(endpoint: String)
    case invalidCSVFormat(message: String)
    case invalidBaseURL(url: String)
    case s3Error(message: String)
    case httpError(status: Int)
    case baseURLNotConfigured
    case invalidAPIResponse
    case emptyDictionary
    
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
