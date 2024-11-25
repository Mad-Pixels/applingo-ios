import Foundation

class RepositoryAPI: ApiRepositoryProtocol {
    func getCategories() async throws -> CategoryItemModel {
        let endpoint = "/v1/categories"
        
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
                queryItems.append(URLQueryItem(name: "is_public", value: isPublic ? "1" : "0"))
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
                id: UUID().hashValue,
                displayName: dictionaryItem.name,
                tableName: dictionaryItem.dictionary,
                description: dictionaryItem.description,
                category: dictionaryItem.category,
                subcategory: dictionaryItem.subcategory,
                author: dictionaryItem.author,
                createdAt: dictionaryItem.createdAt,
                isPublic: (dictionaryItem.isPublic != 0)
            )
        }
        return (dictionaries: dictionaries, lastEvaluated: response.data.lastEvaluated)
    }
    
    func downloadDictionary(_ dictionary: DictionaryItemModel) async throws -> URL {
        let endpoint = "/v1/urls"
        let body = try? JSONSerialization.data(
            withJSONObject: ApiDictionaryDownloadRequestModel(
                dictionary: dictionary.tableName
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
