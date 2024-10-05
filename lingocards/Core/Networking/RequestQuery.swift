import Foundation

struct RequestQueryBody: Encodable {
    var category_main: String?
    var category_sub: String?
    var code: String?
    var is_public: Bool?
    var name: String?
    var author: String?
    var dictionary_key: String?
}

struct ResponseQuery: Decodable {
    let data: ResponseQueryBody
}

struct ResponseQueryBody: Decodable {
    let items: [QueryItem]
}

struct QueryItem: Decodable, Identifiable {
    let dictionary_key: String
    let category_main: String
    let category_sub: String
    let description: String
    let author: String
    let name: String
    let id: Int64

    enum CodingKeys: String, CodingKey {
        case name, category_main, category_sub, author, dictionary_key, description
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        dictionary_key = try container.decode(String.self, forKey: .dictionary_key)
        category_main = try container.decode(String.self, forKey: .category_main)
        category_sub = try container.decode(String.self, forKey: .category_sub)
        description = try container.decode(String.self, forKey: .description)
        author = try container.decode(String.self, forKey: .author)
        name = try container.decode(String.self, forKey: .name)

        id = Int64(Date().timeIntervalSince1970)
    }
}

class RequestQuery {
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol

    init(apiManager: any APIManagerProtocol, logger: any LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
    }

    func invoke<T: Decodable>(requestBody: RequestQueryBody) async throws -> T {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            let responseData = try await apiManager.request(endpoint: "/device/v1/dictionary/query", method: .post, body: bodyData)
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: responseData)
            return decodedResponse
        } catch let error as APIError {
            logger.log("API Query request failed: \(error)", level: .error, details: nil)
            throw error
        } catch {
            if let requestBodyDict = try? requestBody.toDictionary() {
                logger.log(
                    "API Query request encoding or decoding error: \(error)",
                    level: .error,
                    details: requestBodyDict
                )
            } else {
                logger.log(
                    "API Query request encoding or decoding error: \(error)",
                    level: .error,
                    details: ["error": "Failed to convert request body to dictionary"]
                )
            }
            throw APIError.decodingError(error)
        }
    }
}
