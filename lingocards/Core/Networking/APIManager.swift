import Foundation
import CryptoKit

// Протокол, определяющий методы для работы с API
protocol APIManagerProtocol {
    func get<T: Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void)
    func post<T: Encodable, U: Decodable>(endpoint: String, body: T, completion: @escaping (Result<U, APIError>) -> Void)
}

// Класс для выполнения сетевых запросов
class APIManager: APIManagerProtocol {
    private let logger: LoggerProtocol
    private let session: URLSession
    private let baseURL: String
    private let token: String
    
    init(baseURL: String, token: String, logger: LoggerProtocol, session: URLSession = .shared) {
        self.session = session
        self.baseURL = baseURL
        self.logger = logger
        self.token = token
    }
    
    private func prepareRequest(for url: URL, method: String, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let timestamp = String(Int(Date().timeIntervalSince1970))
        request.setValue(timestamp, forHTTPHeaderField: "x-timestamp")
        
        let signatureInput: String
        signatureInput = "\(timestamp)\(url.path)"
        
        let signature = generateSignature(input: signatureInput)
        request.setValue(signature, forHTTPHeaderField: "x-signature")
        
        if method == "POST" {
            request.httpBody = body
        }
        return request
    }
    
    private func generateSignature(input: String) -> String {
        let key = SymmetricKey(data: Data(token.utf8))
        let signature = HMAC<SHA256>.authenticationCode(for: Data(input.utf8), using: key)
        return Data(signature).base64EncodedString()
    }
    
    // Метод для выполнения GET-запросов
    func get<T: Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError(NSError(domain: "No Data", code: 0, userInfo: nil))))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
    
    // Метод для выполнения POST-запросов
    func post<T: Encodable, U: Decodable>(endpoint: String, body: T, completion: @escaping (Result<U, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(body)
            request.httpBody = jsonData
        } catch {
            completion(.failure(.decodingError(error)))
            return
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.networkError(NSError(domain: "No Data", code: 0, userInfo: nil))))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(U.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
