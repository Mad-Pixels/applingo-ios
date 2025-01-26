import Foundation
import CryptoKit

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
    
    func downloadS3(from urlString: String) async throws -> URL {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidEndpointURL(endpoint: urlString)
        }
        
        let (localURL, urlResponse) = try await session.download(from: url)
        
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
    
    func request(endpoint: String, method: HTTPMethod, queryItems: [URLQueryItem]? = nil, body: Data? = nil) async throws -> Data {
       guard !baseURL.isEmpty else {
           throw APIError.baseURLNotConfigured
       }

       guard var urlComponents = URLComponents(string: baseURL) else {
           throw APIError.invalidBaseURL(url: baseURL)
       }

       urlComponents.path += endpoint
       urlComponents.queryItems = queryItems

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

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201  else {
            if let apiErrorMessage = try? JSONDecoder().decode(ApiErrorMessageModel.self, from: data) {
                throw APIError.apiErrorMessage(message: apiErrorMessage.message, statusCode: httpResponse.statusCode)
            } else {
                throw APIError.httpError(status: httpResponse.statusCode)
            }
        }
        return data
    }
    
    private func signRequest(for url: URL, method: HTTPMethod, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let timestamp = String(Int(Date().timeIntervalSince1970))
        let signature = generateSignature(timestamp: timestamp)
            
        let combinedAuth = "\(timestamp):::\(signature)"
        request.setValue(combinedAuth, forHTTPHeaderField: "x-api-auth")
            
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
