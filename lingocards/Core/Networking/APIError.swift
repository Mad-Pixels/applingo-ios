import Foundation

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
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)

        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            throw NSError(domain: "InvalidConversion", code: 0, userInfo: nil)
        }
        return dictionary
    }
}
