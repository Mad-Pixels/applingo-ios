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
    
    func getDictionaries() async throws -> [DictionaryItemModel] {
        struct DictionaryResponse: Codable {
            let data: DictionaryItems
        }
        struct DictionaryItems: Codable {
            let items: [DictionaryItem]
        }
        struct DictionaryItem: Codable {
            let name: String
            let categoryMain: String
            let categorySub: String
            let author: String
            let dictionaryKey: String
            let description: String

            enum CodingKeys: String, CodingKey {
                case dictionaryKey = "dictionary_key"
                case categoryMain = "category_main"
                case categorySub = "category_sub"
                case description
                case author
                case name
            }
        }
        
        let endpoint = "/device/v1/dictionary/query"
        let body = "{}".data(using: .utf8)
        let method: HTTPMethod = .post
        
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(DictionaryResponse.self, from: data)
        Logger.debug("[RepositoryAPI]: getDictionaries - fetched")
        
        return response.data.items.map { dictionaryItem in
            DictionaryItemModel(
                id: UUID().hashValue,
                displayName: dictionaryItem.name,
                tableName: dictionaryItem.dictionaryKey,
                description: dictionaryItem.description,
                category: dictionaryItem.categoryMain,
                subcategory: dictionaryItem.categorySub,
                author: dictionaryItem.author,
                createdAt: Int(Date().timeIntervalSince1970),
                isPrivate: false,
                isActive: true
            )
        }
    }
}
