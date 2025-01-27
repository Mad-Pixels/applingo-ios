import Foundation

/// A model representing a request for querying dictionaries via the API.
struct ApiDictionaryQueryRequestModel: Codable, Equatable {
    // MARK: - Properties

    /// The subcategory to filter the dictionaries.
    var subcategory: String?

    /// A flag indicating whether the dictionaries should be public.
    var isPublic: Bool?

    /// The field by which to sort the results.
    var sortBy: String?

    /// The last evaluated key for paginated queries.
    var lastEvaluated: String?

    // MARK: - Initialization

    /// Initializes the request model with optional parameters.
    /// - Parameters:
    ///   - subcategory: The subcategory to filter the dictionaries.
    ///   - isPublic: A flag indicating whether to filter public dictionaries.
    ///   - sortBy: The field to sort results by. Accepts `ApiSortType`.
    ///   - lastEvaluated: The last evaluated key for paginated queries.
    init(
        subcategory: String? = nil,
        isPublic: Bool? = nil,
        sortBy: ApiSortType? = nil,
        lastEvaluated: String? = nil
    ) {
        self.subcategory = subcategory
        self.isPublic = isPublic
        self.sortBy = sortBy?.rawValue
        self.lastEvaluated = lastEvaluated
    }

    // MARK: - Methods

    /// Converts the model into a dictionary representation suitable for API requests.
    /// - Returns: A dictionary containing non-nil properties.
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        if let subcategory {
            dict["subcategory"] = subcategory
        }
        if let isPublic {
            dict["is_public"] = isPublic
        }
        if let sortBy {
            dict["sort_by"] = sortBy
        }
        if let lastEvaluated {
            dict["last_evaluated"] = lastEvaluated
        }
        return dict
    }
}
