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
    
    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func invoke<T: Decodable>(requestBody: RequestDownloadBody, completion: @escaping (Result<T, APIError>) -> Void) {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            apiManager.post(endpoint: "/device/v1/dictionary/download_url", body: bodyData) { result in
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
