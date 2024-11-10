import Foundation

class RepositoryAPI: ApiRepositoryProtocol {
    func getCategories() async throws -> CategoryItemModel {
        let endpoint = "/device/v1/category/query"
        let body = "{}".data(using: .utf8)
        
        let data = try await APIManager.shared.request(
            endpoint: endpoint,
            method: .post,
            body: body
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
        let endpoint = "/device/v1/dictionary/querys"
        let body = try? JSONSerialization.data(withJSONObject: request?.toDictionary() ?? [:])
            
        let data = try await APIManager.shared.request(
            endpoint: endpoint,
            method: .post,
            body: body
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
        let endpoint = "/device/v1/dictionary/download_url"
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
