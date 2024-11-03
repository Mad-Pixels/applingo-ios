import Foundation
import CryptoKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

enum APIError: Error {
    case baseURLNotConfigured
    case invalidBaseURL(url: String)
    case invalidEndpointURL(endpoint: String)
    case invalidAPIResponse
    case apiErrorMessage(message: String, statusCode: Int)
    case httpError(statusCode: Int)
}

class APIManager {
    static let shared = APIManager()
    
    private let session: URLSession
    private var baseURL: String = ""
    private var token: String = ""

    private init(session: URLSession = .shared) {
        self.session = session
    }
    
    static func configure(baseURL: String, token: String) {
        shared.baseURL = baseURL
        shared.token = token
    }
    
    func request(endpoint: String, method: HTTPMethod, body: Data? = nil) async throws -> Data {
        guard !baseURL.isEmpty else {
            throw APIError.baseURLNotConfigured
        }

        guard var urlComponents = URLComponents(string: baseURL) else {
            throw APIError.invalidBaseURL(url: baseURL)
        }
        urlComponents.path += endpoint

        guard let url = urlComponents.url else {
            throw APIError.invalidEndpointURL(endpoint: endpoint)
        }

        let request = try signRequest(for: url, method: method, body: body)
        Logger.debug("[APIManager]: sent request - \(request)")

        let (data, response) = try await session.data(for: request)
        return try handleResponse(response: response, data: data)
    }
    
    private func handleResponse(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidAPIResponse
        }

        guard httpResponse.statusCode == 200 else {
            if let apiErrorMessage = try? JSONDecoder().decode(APIErrorMessage.self, from: data) {
                throw APIError.apiErrorMessage(message: apiErrorMessage.message, statusCode: httpResponse.statusCode)
            } else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
        }
        return data
    }
    
    private func signRequest(for url: URL, method: HTTPMethod, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        let timestamp = String(Int(Date().timeIntervalSince1970))
        let signature = generateSignature(input: timestamp)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue(timestamp, forHTTPHeaderField: "x-timestamp")
        
        if method == .post, let body = body {
            request.httpBody = body
        }
        return request
    }
    
    private func generateSignature(input: String) -> String {
        let signature = HMAC<SHA256>.authenticationCode(for: Data(input.utf8), using: SymmetricKey(data: Data(token.utf8)))
        return Data(signature).map { String(format: "%02hhx", $0) }.joined()
    }
}