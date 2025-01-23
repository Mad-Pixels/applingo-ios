import Foundation

class RepositoryAPI: ApiRepositoryProtocol {
    func getCategories() async throws -> CategoryItemModel {
        let endpoint = "/v1/subcategories"
        
        let data = try await APIManager.shared.request(
            endpoint: endpoint,
            method: .get,
            body: nil
        )
        let response = try JSONDecoder().decode(ApiCategoryGetResponseModel.self, from: data)
        Logger.debug("[RepositoryAPI]: getCategories - fetched")
        return response.data
    }
    
    func getDictionaries(
        request: ApiDictionaryQueryRequestModel? = nil
    ) async throws -> (
        dictionaries: [DictionaryItemModel],
        lastEvaluated: String?
    ) {
        let endpoint = "/v1/dictionaries"
        
        var queryItems: [URLQueryItem] = []
        
        if let request = request {
            if let subcategory = request.subcategory {
                queryItems.append(URLQueryItem(name: "subcategory", value: subcategory))
            }
            if let isPublic = request.isPublic {
                queryItems.append(URLQueryItem(name: "public", value: isPublic ? "true" : "false"))
            }
            if let sortBy = request.sortBy {
                queryItems.append(URLQueryItem(name: "sort_by", value: sortBy))
            }
            if let lastEvaluated = request.lastEvaluated {
                queryItems.append(URLQueryItem(name: "last_evaluated", value: lastEvaluated))
            }
        }
        
        let data = try await APIManager.shared.request(
            endpoint: endpoint,
            method: .get,
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        
        let response = try JSONDecoder().decode(ApiDictionaryQueryResponseModel.self, from: data)
        
        let dictionaries = response.data.items.map { dictionaryItem in
            DictionaryItemModel(
                uuid: dictionaryItem.dictionary,
                name: dictionaryItem.name,
                author: dictionaryItem.author,
                category: dictionaryItem.category,
                subcategory: dictionaryItem.subcategory,
                description: dictionaryItem.description,
                
                created: dictionaryItem.createdAt,
                id: UUID().hashValue
            )
        }
        return (dictionaries: dictionaries, lastEvaluated: response.data.lastEvaluated)
    }
    
    func downloadDictionary(_ dictionary: DictionaryItemModel) async throws -> URL {
        let endpoint = "/v1/urls"
        let body = try? JSONSerialization.data(
            withJSONObject: ApiDictionaryDownloadRequestModel(
                dictionary: dictionary.uuid
            ).toDictionary()
        )

        let data = try await APIManager.shared.request(
            endpoint: endpoint,
            method: .post,
            body: body
        )
        
        let response = try JSONDecoder().decode(ApiDictionaryDownloadResponseModel.self, from: data)
        Logger.debug("[RepositoryAPI]: downloadDictionary pre-signed URL fetched")
        return try await APIManager.shared.downloadS3(from: response.data.url)
    }
}
