import Foundation

final class ApiManagerRequest {
   // MARK: - Constants
   private enum Endpoints {
       static let dictionaries = "/v1/dictionaries"
       static let categories = "/v1/subcategories"
       static let urls = "/v1/urls"
   }
   
   private enum Constants {
       static let loggerTag = "[ApiRequest]"
   }

   // MARK: - Public Methods
   func getCategories() async throws -> CategoryItemModel {
       let data = try await AppAPI.shared.request(
           endpoint: Endpoints.categories,
           method: .get
       )
       let response = try JSONDecoder().decode(ApiCategoryGetResponseModel.self, from: data)
       Logger.debug("\(Constants.loggerTag): getCategories - fetched")
       return response.data
   }
   
   func getDictionaries(
       request: ApiDictionaryQueryRequestModel? = nil
   ) async throws -> (dictionaries: [DatabaseModelDictionary], lastEvaluated: String?) {
       let queryItems = buildDictionaryQueryItems(from: request)
       let data = try await AppAPI.shared.request(
           endpoint: Endpoints.dictionaries,
           method: .get,
           queryItems: queryItems.isEmpty ? nil : queryItems
       )
       
       let response = try JSONDecoder().decode(ApiDictionaryQueryResponseModel.self, from: data)
       
       let dictionaries = response.data.items.map { dictionaryItem in
           DatabaseModelDictionary(
               guid: dictionaryItem.dictionary,
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
   
   func downloadDictionary(_ dictionary: DatabaseModelDictionary) async throws -> URL {
       let body = try? JSONSerialization.data(
           withJSONObject: ApiDictionaryDownloadRequestModel(
               dictionary: dictionary.guid
           ).toDictionary()
       )

       let data = try await AppAPI.shared.request(
           endpoint: Endpoints.urls,
           method: .post,
           body: body
       )
       
       let response = try JSONDecoder().decode(ApiDictionaryDownloadResponseModel.self, from: data)
       Logger.debug("\(Constants.loggerTag): downloadDictionary pre-signed URL fetched")
       return try await AppAPI.shared.downloadS3(from: response.data.url)
   }
   
   // MARK: - Private Methods
   private func buildDictionaryQueryItems(from request: ApiDictionaryQueryRequestModel?) -> [URLQueryItem] {
       var items: [URLQueryItem] = []
       
       guard let request = request else { return items }
       
       if let subcategory = request.subcategory {
           items.append(URLQueryItem(name: "subcategory", value: subcategory))
       }
       if let isPublic = request.isPublic {
           items.append(URLQueryItem(name: "public", value: isPublic ? "true" : "false"))
       }
       if let sortBy = request.sortBy {
           items.append(URLQueryItem(name: "sort_by", value: sortBy))
       }
       if let lastEvaluated = request.lastEvaluated {
           items.append(URLQueryItem(name: "last_evaluated", value: lastEvaluated))
       }
       
       return items
   }
}
