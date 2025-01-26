import Foundation
import CryptoKit

final class AppAPI: ObservableObject {
    // MARK: - Constants
    private enum Constants {
        static let contentType = "application/json"
        static let authHeader = "x-api-auth"
        static let loggerTag = "[AppAPI]"
    }
   
    // MARK: - Properties
    @Published private(set) var isConfigured: Bool = false
    static let shared = AppAPI()
   
    private let session: URLSession
    private var baseURL: String = ""
    private var token: String = ""
   
    // MARK: - Init
    private init(session: URLSession = .shared) {
        self.session = session
    }
   
    // MARK: - Configuration
    static func configure(baseURL: String, token: String) {
        shared.baseURL = baseURL
        shared.token = token
        shared.isConfigured = true
    }
   
    // MARK: - Public Methods
    func downloadS3(from urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidEndpointURL(endpoint: urlString)
        }
       
        let (localURL, urlResponse) = try await session.download(from: url)
        return try validateS3Response(localURL: localURL, urlResponse: urlResponse)
    }
   
    func request(
        endpoint: String,
        method: HTTPMethodType,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) async throws -> Data {
        guard !baseURL.isEmpty else { throw APIError.baseURLNotConfigured }
       
        let url = try buildURL(endpoint: endpoint, queryItems: queryItems)
        let request = try signRequest(for: url, method: method, body: body)
       
        Logger.debug("\(Constants.loggerTag): sent request - \(request)")
        let (data, response) = try await session.data(for: request)
        return try handleResponse(response: response, data: data)
    }
   
    // MARK: - Private Methods
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
   
    private func handleResponse(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidAPIResponse
        }
       
        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            if let apiErrorMessage = try? JSONDecoder().decode(ApiErrorMessageModel.self, from: data) {
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
   
    private func generateSignature(timestamp: String) -> String {
        let key = SymmetricKey(data: Data(token.utf8))
        let dataToSign = Data(timestamp.utf8)
        let signature = HMAC<SHA256>.authenticationCode(for: dataToSign, using: key)
        return signature.map { String(format: "%02x", $0) }.joined()
    }
}
