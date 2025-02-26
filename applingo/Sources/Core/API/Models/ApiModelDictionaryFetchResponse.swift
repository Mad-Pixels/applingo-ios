import Foundation

/// A model representing the response for a dictionary download request from the API.
struct ApiModelDictionaryFetchResponse: Codable {
    // MARK: - Properties

    /// The data payload containing the download information.
    let data: DownloadData

    // MARK: - Nested Types

    /// A nested model representing the details of the download data.
    struct DownloadData: Codable {
        /// The URL where the dictionary file can be downloaded.
        let url: String
    }
}
