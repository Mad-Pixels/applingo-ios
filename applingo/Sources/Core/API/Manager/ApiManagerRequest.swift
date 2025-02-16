import Foundation

/// A manager for making API requests related to dictionaries and categories.
final class ApiManagerRequest {
    // MARK: - Constants
    
    /// Endpoints for API requests.
    private enum Endpoints {
        static let dictionaries = "/v1/dictionaries"
        static let categories = "/v1/subcategories"
        static let statistic = "/v1/dictionary/statistic"
        static let urls = "/v1/urls"
    }
        
    // MARK: - Public Methods
    
    /// Fetches the list of categories from the API.
    /// - Returns: An `ApiModelCategoryItem` containing the fetched categories.
    /// - Throws: An `APIError` if the API request fails or decoding fails.
    func getCategories() async throws -> ApiModelCategoryItem {
        Logger.debug("[API]: Fetching categories from API...")
        
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.categories,
            method: .get
        )
        
        do {
            let response = try JSONDecoder().decode(ApiModelCategoryGetResponse.self, from: data)
            Logger.debug(
                "[API]: Fetched categories",
                metadata: [
                    "categories": String(describing: response.data)
                ]
            )
            return response.data
        } catch {
            throw APIError.invalidAPIResponse
        }
    }
    
    /// Fetches dictionaries from the API based on the given query parameters.
    /// - Parameter request: A request model containing query parameters. Defaults to `nil`.
    /// - Returns: A tuple containing the fetched dictionaries and the `lastEvaluated` value (if any).
    /// - Throws: An `APIError` if the API request fails or decoding fails.
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
        
        do {
            let response = try JSONDecoder().decode(ApiModelDictionaryQueryResponse.self, from: data)
            Logger.debug(
                "[API]: Dictionaries fetched from API",
                metadata: [
                    "fetchedItems": response.data.items.count,
                    "lastEvaluated": response.data.lastEvaluated ?? "None"
                ]
            )
            return (dictionaries: response.data.items, lastEvaluated: response.data.lastEvaluated)
        } catch {
            throw APIError.invalidAPIResponse
        }
    }
    
    /// Downloads a dictionary using a pre-signed URL from the API.
    /// - Parameter dictionary: The dictionary to download.
    /// - Returns: A local URL to the downloaded file.
    /// - Throws: An `APIError` if the API request or the download fails.
    func downloadDictionary(_ dictionary: ApiModelDictionaryItem) async throws -> URL {
        Logger.debug(
            "[API]: Requesting pre-signed URL for dictionary download...",
            metadata: ["dictionary": dictionary.name]
        )
        
        let body = try? JSONSerialization.data(
            withJSONObject: ApiModelDictionaryFetchRequest(from: dictionary.dictionary).toDictionary()
        )
        
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.urls,
            method: .post,
            body: body
        )
        
        do {
            let response = try JSONDecoder().decode(ApiModelDictionaryFetchResponse.self, from: data)
            Logger.debug(
                "[API]: Pre-signed URL fetched",
                metadata: ["url": response.data.url]
            )
            
            // Create destination URL in the temporary directory using the dictionary name.
            let tempDir = FileManager.default.temporaryDirectory
            let destinationURL = tempDir.appendingPathComponent(dictionary.dictionary)
            
            // Download the file directly to the destination URL.
            let fileURL = try await AppAPI.shared.downloadS3(
                from: response.data.url,
                to: destinationURL
            )
            
            Logger.debug(
                "[API]: Dictionary downloaded successfully",
                metadata: ["fileURL": fileURL.path]
            )
            return fileURL
        } catch {
            // If decoding or download fails, classify the error appropriately.
            throw APIError.s3Error(message: error.localizedDescription)
        }
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
    
    /// Sends a PATCH request to update the dictionary statistics,
    /// increasing both "downloads" and "rating", and includes additional query parameters.
    /// - Parameters:
    ///   - name: The dictionary name (min 2, max 36 characters).
    ///   - author: The dictionary author (alphanum, min 2, max 24 characters).
    ///   - subcategory: The dictionary subcategory (exactly 5 letters, e.g. "ru-il").
    /// - Throws: An `APIError` if the request fails.
    func patchDictionaryStatistic(name: String, author: String, subcategory: String) async throws {
        Logger.debug("[API]: Patching dictionary statistic...")
        
        let requestBody: [String: String] = [
            "downloads": "increase",
            "rating": "increase"
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        
        let queryItems = [
            URLQueryItem(name: "name", value: name),
            URLQueryItem(name: "author", value: author),
            URLQueryItem(name: "subcategory", value: subcategory)
        ]
        let data = try await AppAPI.shared.request(
            endpoint: Endpoints.statistic,
            method: .patch,
            queryItems: queryItems,
            body: bodyData
        )
        if let responseString = String(data: data, encoding: .utf8) {
            Logger.debug(
                "[API]: Dictionary statistic patched successfully",
                metadata: [
                    "response": responseString
                ]
            )
        }
    }
}
