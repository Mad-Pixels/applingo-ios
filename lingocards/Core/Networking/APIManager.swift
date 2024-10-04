import Foundation
import CryptoKit

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol APIManagerProtocol {
    func request(endpoint: String, method: HTTPMethod, body: Data?) async throws -> Data
}

class APIManager: APIManagerProtocol {
    private let logger: LoggerProtocol
    private let session: URLSession
    private let baseURL: String
    private let token: String
    
    init(baseURL: String, token: String, logger: any LoggerProtocol, session: URLSession = .shared) {
        self.session = session
        self.baseURL = baseURL
        self.logger = logger
        self.token = token
    }
    
    func request(endpoint: String, method: HTTPMethod, body: Data? = nil) async throws -> Data {
        guard var urlComponents = URLComponents(string: baseURL) else {
            logger.log("Invalid base URL: \(baseURL)", level: .error, details: nil)
            throw APIError.invalidURL
        }
        urlComponents.path = urlComponents.path + endpoint

        guard let url = urlComponents.url else {
            logger.log("Invalid URL with endpoint: \(endpoint)", level: .error, details: nil)
            throw APIError.invalidURL
        }

        do {
            let request = try signRequest(for: url, method: method, body: body)
            let (data, response) = try await session.data(for: request)
            logger.log("Request sent: \(request)", level: .info, details: nil)
            return try handleResponse(response: response, data: data)
        } catch {
            logger.log("API \(method.rawValue) request failed: \(error)", level: .error, details: ["url": url.absoluteString])
            throw error
        }
    }
    
    private func handleResponse(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            logger.log("Invalid response type", level: .error, details: nil)
            throw APIError.networkError(NSError(domain: "Invalid Response", code: 0, userInfo: nil))
        }

        guard httpResponse.statusCode == 200 else {
            do {
                let apiErrorMessage = try JSONDecoder().decode(APIErrorMessage.self, from: data)
                logger.log(
                    "API request failed with error: \(apiErrorMessage.Message)",
                    level: .error,
                    details: ["statusCode": httpResponse.statusCode]
                )
                throw APIError.apiError(apiErrorMessage.Message)
            } catch {
                logger.log(
                    "Failed to decode API error message: \(error)",
                    level: .error,
                    details: ["statusCode": httpResponse.statusCode, "data": String(decoding: data, as: UTF8.self)]
                )
                throw APIError.unknownResponseError
            }
        }

        return data
    }
    
    private func signRequest(for url: URL, method: HTTPMethod, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        
        let timestamp = String(Int(Date().timeIntervalSince1970))
        let signature = generateSignature(input: timestamp)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        request.setValue(timestamp, forHTTPHeaderField: "x-timestamp")
        request.httpMethod = method.rawValue
        
        if method == .post {
            request.httpBody = body
        }
        return request
    }
    
    private func generateSignature(input: String) -> String {
        let signature = HMAC<SHA256>.authenticationCode(for: Data(input.utf8), using: SymmetricKey(data: Data(token.utf8)))
        let signatureData = Data(signature)
        return signatureData.map { String(format: "%02hhx", $0) }.joined()
    }
}
