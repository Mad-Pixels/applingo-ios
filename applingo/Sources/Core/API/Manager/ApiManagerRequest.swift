import Foundation

/// A manager for making API requests related to dictionaries and categories.
final class ApiManagerRequest {
    // MARK: - Constants
    
    /// Endpoints for API requests.
    private enum Endpoints {
        static let dictionaries = "/v1/dictionaries"
        static let categories = "/v1/subcategories"
        static let urls = "/v1/urls"
    }
        
    // MARK: - Public Methods
    
    /// Fetches the list of categories from the API.
    /// - Returns: A `ApiModelCategoryItem` containing the fetched categories.
    /// - Throws: An error if the API request fails or decoding fails.
    func getCategories() async throws -> ApiModelCategoryItem {
        Logger.debug("[API]: Fetching categories from API...")
        
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.categories,
            method: .get
        )
        let response = try JSONDecoder().decode(ApiModelCategoryGetResponse.self, from: data)
        Logger.debug(
            "[API]: Fetched categories",
            metadata: ["categories": String(describing: response.data)]
        )
        return response.data
    }
    
    /// Fetches dictionaries from the API based on the given query parameters.
    /// - Parameter request: A request model containing query parameters. Defaults to `nil`.
    /// - Returns: A tuple containing the fetched dictionaries and the `lastEvaluated` value (if any).
    /// - Throws: An error if the API request fails or decoding fails.
    func getDictionaries(
        request: ApiModelDictionaryQueryRequest? = nil
    ) async throws -> (dictionaries: [ApiModelDictionaryItem], lastEvaluated: String?) {
        Logger.debug(
            "[API]: Fetching dictionaries from API...",
            metadata: ["request": String(describing: request)]
        )
        
        let queryItems = buildDictionaryQueryItems(from: request)
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.dictionaries,
            method: .get,
            queryItems: queryItems.isEmpty ? nil : queryItems
        )
        
        let response = try JSONDecoder().decode(ApiModelDictionaryQueryResponse.self, from: data)
        Logger.debug(
            "[API]: Dictionaries fetched from API",
            metadata: [
                "fetchedItems": response.data.items.count,
                "lastEvaluated": response.data.lastEvaluated ?? "None"
            ]
        )

        return (dictionaries: response.data.items, lastEvaluated: response.data.lastEvaluated)
    }
    
    /// Downloads a dictionary using a pre-signed URL from the API.
    /// - Parameter dictionary: The dictionary to download.
    /// - Returns: A local URL to the downloaded file.
    /// - Throws: An error if the API request or the download fails.
    func downloadDictionary(_ dictionary: ApiModelDictionaryItem) async throws -> URL {
        Logger.debug(
            "[API]: Requesting pre-signed URL for dictionary download...",
            metadata: ["dictionary": dictionary.name]
        )
        
        let body = try? JSONSerialization.data(
            withJSONObject: ApiModelDictionaryFetchRequest(
                from: dictionary.dictionary
            ).toDictionary()
        )
        
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.urls,
            method: .post,
            body: body
        )
        
        let response = try JSONDecoder().decode(ApiModelDictionaryFetchResponse.self, from: data)
        
        Logger.debug(
            "[API]: Pre-signed URL fetched",
            metadata: ["url": response.data.url]
        )
        
        // Создаем URL с правильным именем файла
        let tempDir = FileManager.default.temporaryDirectory
        let destinationURL = tempDir.appendingPathComponent(dictionary.dictionary)
        
        // Скачиваем файл сразу в нужное место с нужным именем
        let fileURL = try await AppAPI.shared.downloadS3(
            from: response.data.url,
            to: destinationURL
        )
        
        Logger.debug(
            "[API]: Dictionary downloaded successfully",
            metadata: ["fileURL": fileURL.path]
        )
        return fileURL
    }
    
    // MARK: - Private Methods
    
    /// Builds query parameters for a dictionary API request.
    /// - Parameter request: A request model containing query parameters. Defaults to `nil`.
    /// - Returns: An array of `URLQueryItem` representing the query parameters.
    private func buildDictionaryQueryItems(from request: ApiModelDictionaryQueryRequest?) -> [URLQueryItem] {
        var items: [URLQueryItem] = []
        
        guard let request = request else { return items }
        
        if let subcategory = request.subcategory {
            items.append(URLQueryItem(name: "subcategory", value: subcategory))
        }
        if let level = request.level {
            items.append(URLQueryItem(name: "level", value: level))
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
        
        Logger.debug(
            "[API]: Built query items",
            metadata: ["queryItems": items.map { $0.name + "=" + ($0.value ?? "") }]
        )
        
        return items
    }
}
