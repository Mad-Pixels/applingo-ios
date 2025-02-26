import Foundation

/// A model representing the response for a GET request to fetch a category from the API.
struct ApiModelCategoryGetResponse: Codable {
    // MARK: - Properties

    /// The category data returned from the API.
    let data: ApiModelCategoryItem
}
