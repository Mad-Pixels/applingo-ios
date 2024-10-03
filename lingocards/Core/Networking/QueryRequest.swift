import Foundation

// Структура тела запроса
struct QueryRequestBody: Encodable {
    var category_main: String?
    var category_sub: String?
    var code: String?
    var is_public: Bool?
    var name: String?
    var author: String?
    var dictionary_key: String?
}

// Структура ответа
struct QueryResponse: Decodable {
    let data: QueryResponseData
}

struct QueryResponseData: Decodable {
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

class QueryRequest {
    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }

    func query<T: Decodable>(requestBody: QueryRequestBody, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            apiManager.post(endpoint: "/device/v1/dictionary/query", body: bodyData) { result in
                switch result {
                case .success(let data):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(decodedResponse))
                    } catch {
                        completion(.failure(.decodingError(error)))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.decodingError(error)))
        }
    }
}
