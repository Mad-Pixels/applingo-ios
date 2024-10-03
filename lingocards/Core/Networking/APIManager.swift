import Foundation
import CryptoKit

// Протокол, определяющий методы для работы с API
protocol APIManagerProtocol {
    func get(endpoint: String, completion: @escaping (Result<Data, APIError>) -> Void)
    func post(endpoint: String, body: Data, completion: @escaping (Result<Data, APIError>) -> Void)
}

// Класс для выполнения сетевых запросов
class APIManager: APIManagerProtocol {
    let logger: LoggerProtocol
    
    private let session: URLSession
    private let baseURL: String
    private let token: String
    
    init(baseURL: String, token: String, logger: LoggerProtocol, session: URLSession = .shared) {
        self.session = session
        self.baseURL = baseURL
        self.logger = logger
        self.token = token
    }
    
    private func signRequest(for url: URL, method: String, body: Data? = nil) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let timestamp = String(Int(Date().timeIntervalSince1970))
        request.setValue(timestamp, forHTTPHeaderField: "x-timestamp")

        let signatureInput = timestamp
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
        let signatureData = Data(signature)
        let signatureHex = signatureData.map { String(format: "%02hhx", $0) }.joined()
        return signatureHex
    }
    
    // Метод для выполнения GET-запросов
    func get(endpoint: String, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }
        
        do {
            let request = try signRequest(for: url, method: "GET")
            let task = session.dataTask(with: request) { data, response, error in
                self.handleResponse(data: data, response: response, error: error, completion: completion)
            }
            task.resume()
        } catch {
            completion(.failure(.invalidSignature))
        }
    }
    
    // Метод для выполнения POST-запросов
    func post(endpoint: String, body: Data, completion: @escaping (Result<Data, APIError>) -> Void) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(.invalidURL))
            return
        }

        do {
            logger.log("API request: \(url)", level: .info, details: nil)
            let request = try signRequest(for: url, method: "POST", body: body)

            let task = session.dataTask(with: request) { data, response, error in
                self.handleResponse(data: data, response: response, error: error, completion: completion)
            }
            task.resume()
        } catch {
            completion(.failure(.invalidSignature))
        }
    }
    
    // Метод для обработки ответа
    private func handleResponse(data: Data?, response: URLResponse?, error: Error?, completion: @escaping (Result<Data, APIError>) -> Void) {
        if let error = error {
            logger.log("API request failed: \(error.localizedDescription)", level: .error, details: nil)
            completion(.failure(.networkError(error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(.networkError(NSError(domain: "Invalid Response", code: 0, userInfo: nil))))
            return
        }

        guard let data = data else {
            completion(.failure(.networkError(NSError(domain: "No Data", code: 0, userInfo: nil))))
            return
        }

        logger.log("API response: \(String(decoding: data, as: Unicode.UTF8.self))", level: .debug, details: nil)

        if httpResponse.statusCode == 200 {
            logger.log("API request successful", level: .info, details: nil)
            completion(.success(data))
        } else {
            // Попытка разобрать сообщение об ошибке
            if let apiErrorMessage = try? JSONDecoder().decode(APIErrorMessage.self, from: data) {
                logger.log("API request failed with error: \(apiErrorMessage.Message)", level: .error, details: nil)
                completion(.failure(.apiError(apiErrorMessage.Message)))
            } else {
                logger.log("Unknown response error", level: .error, details: nil)
                completion(.failure(.unknownResponseError))
            }
        }
    }
}
