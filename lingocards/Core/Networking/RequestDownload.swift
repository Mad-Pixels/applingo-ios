import Foundation

struct RequestDownloadBody: Encodable {
    let dictionary_key: String
}

struct ResponseDownload: Decodable {
    let data: ResponseDownloadBody
}

struct ResponseDownloadBody: Decodable {
    let url: String
}

class RequestDownload {
    private let apiManager: APIManagerProtocol
    private let logger: LoggerProtocol
    
    init(apiManager: any APIManagerProtocol, logger: any LoggerProtocol) {
        self.apiManager = apiManager
        self.logger = logger
    }
    
    func invoke<T: Decodable>(requestBody: RequestDownloadBody) async throws -> T {
        do {
            let bodyData = try JSONEncoder().encode(requestBody)
            let responseData = try await apiManager.request(
                endpoint: "/device/v1/dictionary/download_urls",
                method: .post,
                body: bodyData
            )
            
            let decodedResponse = try JSONDecoder().decode(T.self, from: responseData)
            return decodedResponse
        } catch let error as APIError {
            logger.log("API Download request failed: \(error)", level: .error, details: nil)
            throw error
        } catch {
            if let requestBodyDict = try? requestBody.toDictionary() {
                logger.log(
                    "API Download request encoding or decoding error: \(error)",
                    level: .error,
                    details: requestBodyDict
                )
            } else {
                logger.log(
                    "API Download request encoding or decoding error: \(error)",
                    level: .error,
                    details: ["error": "Failed to convert request body to dictionary"]
                )
            }
            throw APIError.decodingError(error)
        }
    }
}
