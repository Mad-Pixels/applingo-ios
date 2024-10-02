import Foundation

// Перечисление возможных ошибок при работе с API
enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidSignature
}
