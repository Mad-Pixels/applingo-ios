import Foundation
import CryptoKit

/// A singleton class for managing API requests and S3 downloads.
final class AppAPI: ObservableObject {
    // MARK: - Constants

    private enum Constants {
        static let contentType = "application/json"
        static let authHeader = "x-api-auth"
    }

    // MARK: - Properties

    private static let isInitialized = AtomicBoolean(false)
    static let shared = AppAPI()

    private let session: URLSession
    private var baseURL: String = ""
    private var token: String = ""

    // MARK: - Initialization

    /// Private initializer to ensure singleton usage.
    /// - Parameter session: A custom URLSession instance, default is `.shared`.
    private init(session: URLSession = .shared) {
        self.session = session
    }

    // MARK: - Configuration

    /// Configures the API with a base URL and authentication token.
    /// - Parameters:
    ///   - baseURL: The base URL for API requests.
    ///   - token: The authentication token.
    static func configure(baseURL: String, token: String) {
        guard !isInitialized.value else {
            Logger.debug("[API]: Already configured")
            return
        }

        shared.baseURL = baseURL
        shared.token = token
        isInitialized.value = true

        Logger.debug("[API]: Configured with baseURL \(baseURL)")
    }

    // MARK: - Public Methods

    /// Downloads a file from an S3 URL.
    /// - Parameter urlString: The S3 file URL.
    /// - Returns: A local file URL.
    func downloadS3(from urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidEndpointURL(endpoint: urlString)
        }

        let (localURL, urlResponse) = try await session.download(from: url)
        Logger.debug(
            "[API]: Downloaded S3 file",
            metadata: [
                "url": url.absoluteString,
                "localURL": localURL.path
            ]
        )
        return try validateS3Response(localURL: localURL, urlResponse: urlResponse)
    }

    /// Makes an API request to the specified endpoint.
    /// - Parameters:
    ///   - endpoint: The API endpoint.
    ///   - method: The HTTP method.
    ///   - queryItems: Optional query parameters.
    ///   - body: Optional request body.
    /// - Returns: The response data.
    func request(
        endpoint: String,
        method: HTTPMethodType,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) async throws -> Data {
        guard !baseURL.isEmpty else { throw APIError.baseURLNotConfigured }

        let url = try buildURL(endpoint: endpoint, queryItems: queryItems)
        let request = try signRequest(for: url, method: method, body: body)

        Logger.debug(
            "[API]: Sent request",
            metadata: [
                "url": url.absoluteString,
                "method": method.rawValue
            ]
        )
        let (data, response) = try await session.data(for: request)
        return try handleResponse(response: response, data: data)
    }

    // MARK: - Private Methods

    /// Validates an S3 response for potential errors.
    /// - Parameters:
    ///   - localURL: The local file URL.
    ///   - urlResponse: The URL response.
    /// - Returns: The validated local file URL.
    private func validateS3Response(localURL: URL, urlResponse: URLResponse) throws -> URL {
        if let httpResponse = urlResponse as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw APIError.httpError(status: httpResponse.statusCode)
        }

        let firstBytes = try String(contentsOf: localURL, encoding: .utf8).prefix(1000)
        if firstBytes.contains("<Error>") {
            if firstBytes.contains("NoSuchBucket") {
                throw APIError.s3Error(message: "S3 bucket does not exist")
            } else if firstBytes.contains("AccessDenied") {
                throw APIError.s3Error(message: "Access denied to S3 bucket")
            } else if firstBytes.contains("NoSuchKey") {
                throw APIError.s3Error(message: "File not found in S3 bucket")
            } else {
                throw APIError.s3Error(message: "Unknown S3 error")
            }
        }
        return localURL
    }

    /// Builds a URL for an API request.
    /// - Parameters:
    ///   - endpoint: The API endpoint.
    ///   - queryItems: Optional query parameters.
    /// - Returns: A fully constructed URL.
    private func buildURL(endpoint: String, queryItems: [URLQueryItem]?) throws -> URL {
        guard var components = URLComponents(string: baseURL) else {
            throw APIError.invalidBaseURL(url: baseURL)
        }

        components.path += endpoint
        components.queryItems = queryItems

        guard let url = components.url else {
            throw APIError.invalidEndpointURL(endpoint: endpoint)
        }
        return url
    }

    /// Handles the API response and validates the status code.
    /// - Parameters:
    ///   - response: The URL response.
    ///   - data: The response data.
    /// - Returns: The validated response data.
    private func handleResponse(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidAPIResponse
        }

        Logger.debug(
            "[API]: Received response",
            metadata: [
                "status": httpResponse.statusCode
            ]
        )

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let apiErrorMessage = try? JSONDecoder().decode(ApiModelErrorResponse.self, from: data) {
                throw APIError.apiErrorMessage(
                    message: apiErrorMessage.message,
                    statusCode: httpResponse.statusCode
                )
            } else {
                throw APIError.httpError(status: httpResponse.statusCode)
            }
        }
        return data
    }

    /// Signs the API request with an authentication header.
    /// - Parameters:
    ///   - url: The request URL.
    ///   - method: The HTTP method.
    ///   - body: Optional request body.
    /// - Returns: A signed URLRequest.
    private func signRequest(for url: URL, method: HTTPMethodType, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(Constants.contentType, forHTTPHeaderField: "Content-Type")

        let timestamp = String(Int(Date().timeIntervalSince1970))
        let signature = generateSignature(timestamp: timestamp)
        request.setValue("\(timestamp):::\(signature)", forHTTPHeaderField: Constants.authHeader)

        if method == .post, let body = body {
            request.httpBody = body
        }
        return request
    }

    /// Generates a HMAC signature for authentication.
    /// - Parameter timestamp: The current timestamp.
    /// - Returns: A HMAC signature as a string.
    private func generateSignature(timestamp: String) -> String {
        let key = SymmetricKey(data: Data(token.utf8))
        let dataToSign = Data(timestamp.utf8)
        let signature = HMAC<SHA256>.authenticationCode(for: dataToSign, using: key)
        return signature.map { String(format: "%02x", $0) }.joined()
    }
}
