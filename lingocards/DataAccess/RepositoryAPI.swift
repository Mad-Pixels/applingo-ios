import Foundation

class RepositoryAPI: APIRepositoryProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    func download(dictionaryID: String) async throws -> String {
        let endpoint = "/device/v1/dictionary/download_url"
        let method: HTTPMethod = .post
        
        let requestBody = ["dictionaryID": dictionaryID]
        let bodyData = try JSONEncoder().encode(requestBody)
        
        let data = try await apiManager.request(endpoint: endpoint, method: method, body: bodyData)
        //let response = try JSONDecoder().decode(DownloadURLResponse.self, from: data)
        
//        guard let url = URL(string: response.url) else {
//            throw APIError.invalidEndpointURL(endpoint: response.url)
//        }
        return "url"
    }
    
    func getCategories() async throws -> [CategoryItemModel] {
        let endpoint = "/device/v1/category/query"
        let method: HTTPMethod = .get
        
        let data = try await apiManager.request(endpoint: endpoint, method: method)
        let categories = try JSONDecoder().decode([CategoryItemModel].self, from: data)

        return categories
    }
    
    func getDictionaries(request: DictionaryQueryRequest) async throws -> [DictionaryItemModel] {
        let endpoint = "/device/v1/dictionary/query"
        let method: HTTPMethod = .post
        
        let bodyData = try JSONEncoder().encode(request)
        let data = try await apiManager.request(endpoint: endpoint, method: method, body: bodyData)

        let response = try JSONDecoder().decode(DictionaryQueryResponse.self, from: data)
        return response.data.items
    }
}

