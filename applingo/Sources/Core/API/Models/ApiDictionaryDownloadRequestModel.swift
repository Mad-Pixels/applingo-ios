import Foundation

/// A model representing a request to download a dictionary from the API.
struct ApiDictionaryDownloadRequestModel: Codable {
    // MARK: - Properties

    /// The unique identifier of the dictionary to be downloaded.
    let dictionary: String

    // MARK: - Initialization

    /// Initializes the request model with a dictionary identifier.
    /// - Parameter dictionary: The unique identifier of the dictionary.
    init(from dictionary: String) {
        self.dictionary = dictionary
    }

    // MARK: - Methods

    /// Converts the model into a dictionary representation suitable for API requests.
    /// - Returns: A dictionary containing the key-value pairs for the request body.
    func toDictionary() -> [String: Any] {
        [
            "identifier": dictionary,  // The dictionary identifier
            "operation": "download"    // The operation type
        ]
    }
}
