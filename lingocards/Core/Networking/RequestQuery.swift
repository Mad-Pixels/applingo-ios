import Foundation

// Структура тела запроса
struct RequestQueryBody: Encodable {
    var category_main: String?
    var category_sub: String?
    var code: String?
    var is_public: Bool?
    var name: String?
    var author: String?
    var dictionary_key: String?
}

// Структура ответа
struct ResponseQuery: Decodable {
    let data: ResponseQueryBody
}

struct ResponseQueryBody: Decodable {
    let items: [QueryItem]
}

struct QueryItem: Decodable, Identifiable {
    var id: String { dictionary_key }
    let name: String
    let category_main: String
    let category_sub: String
    let author: String
    let dictionary_key: String
    let description: String
}

class RequestQuery {
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol

    init(apiManager: APIManagerProtocol, logger: LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
    }

    func invoke<T: Decodable>(requestBody: RequestQueryBody, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            apiManager.post(endpoint: "/device/v1/dictionary/query", body: bodyData) { result in
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        self.logger.log("API Query decoding response error: \(error)", level: .error, details: ["body": String(decoding: data, as: UTF8.self)])
                        completion(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    self.logger.log("API Query request failed: \(error)", level: .error, details: nil)
                    completion(.failure(error))
                }
            }
        } catch {
            if let requestBodyDict = try? requestBody.toDictionary() {
                self.logger.log("API Query encoding request error: \(error)", level: .error, details: requestBodyDict)
            } else {
                self.logger.log("API Query encoding request error: \(error)", level: .error, details: ["error": "Failed to convert request body to dictionary"])
            }
            completion(.failure(.decodingError(error)))
        }
    }
}
