import Foundation

class RepositoryAPI: APIRepositoryProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func getCategories() async throws -> CategoryItemModel {
        let endpoint = "/device/v1/category/query"
        let body = "{}".data(using: .utf8)
        let method: HTTPMethod = .post
        
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(ApiCategoryResponseModel.self, from: data)
        Logger.debug("[RepositoryAPI]: getCategories - fetched")
        return response.data
    }
    
    func getDictionaries(request: DictionaryQueryRequest? = nil) async throws -> (dictionaries: [DictionaryItemModel], lastEvaluated: String?) {
        let endpoint = "/device/v1/dictionary/query"
        let body = try? JSONSerialization.data(withJSONObject: request?.toDictionary() ?? [:])
        let method: HTTPMethod = .post
            
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(ApiDictionaryResponseModel.self, from: data)
        Logger.debug("[RepositoryAPI]: getDictionaries - fetched")

        let dictionaries = response.data.items.map { dictionaryItem in
            DictionaryItemModel(
                id: UUID().hashValue,
                displayName: dictionaryItem.name,
                tableName: dictionaryItem.dictionaryKey,
                description: dictionaryItem.description,
                category: dictionaryItem.categorySub,
                subcategory: dictionaryItem.categorySub,
                author: dictionaryItem.author,
                createdAt: Int(Date().timeIntervalSince1970)
            )
        }
        return (dictionaries: dictionaries, lastEvaluated: response.data.lastEvaluated)
    }
}
