import Foundation

// Перечисление возможных ошибок при работе с API
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidSignature
    case apiError(String)
    case unknownResponseError
}

struct APIErrorMessage: Decodable {
    let Message: String
}

extension Encodable {
    /// Преобразование объекта, соответствующего Encodable, в словарь [String: Any]
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "InvalidConversion", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
