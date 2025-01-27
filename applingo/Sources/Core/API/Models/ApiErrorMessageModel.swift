import Foundation

/// A model representing an error message returned by the API.
struct ApiErrorMessageModel: Decodable {
    /// The error message provided by the API.
    let message: String
}
