import Foundation

// Структура тела запроса
struct RequestDownloadBody: Encodable {
    let dictionary_key: String
}

// Структура ответа
struct ResponseDownload: Decodable {
    let data: ResponseQueryBody
}

struct ResponseDownloadBody: Decodable {
    let url: String
}

class RequestDownload {
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol
    
    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
    }
    
    func invoke<T: Decodable>(requestBody: RequestDownloadBody, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            apiManager.post(endpoint: "/device/v1/dictionary/download_urlsss", body: bodyData) { result in
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        self.logger.log("API Download decoding response error: \(error)", level: .error, details: ["body": String(decoding: data, as: UTF8.self)])
                        completion(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    self.logger.log("API Download request failed: \(error)", level: .error, details: nil)
                    completion(.failure(error))
                }
            }
        } catch {
            if let requestBodyDict = try? requestBody.toDictionary() {
                self.logger.log("API Download encoding request error: \(error)", level: .error, details: requestBodyDict)
            } else {
                self.logger.log("API Download encoding request error: \(error)", level: .error, details: ["error": "Failed to convert request body to dictionary"])
            }
            completion(.failure(.decodingError(error)))
        }
    }
}
