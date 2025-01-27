import Foundation

/// A model representing the response for a GET request to fetch a category from the API.
struct ApiCategoryGetResponseModel: Codable {
    // MARK: - Properties

    /// The category data returned from the API.
    let data: CategoryItemModel
}
