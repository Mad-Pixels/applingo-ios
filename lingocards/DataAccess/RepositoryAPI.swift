import Foundation

class RepositoryAPI: APIRepositoryProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func getCategories() async throws -> CategoryItemModel {
        struct CategoryResponse: Codable {
            let data: CategoryItemModel
        }
        
        let endpoint = "/device/v1/category/query"
        let body = "{}".data(using: .utf8)
        let method: HTTPMethod = .post
        
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
        Logger.debug("[RepositoryAPI]: getCategories - fetched")
        return response.data
    }
}
