import Foundation

struct ApiModelDictionaryStatisticRequest: Codable {
    let downloads: String
    let rating: String

    // MARK: - Initialization
    
    init(downloads: String, rating: String) {
        self.downloads = downloads
        self.rating = rating
    }
    
    // MARK: - Methods
    
    static func onDownload() -> ApiModelDictionaryStatisticRequest {
        return ApiModelDictionaryStatisticRequest(downloads: "increase", rating: "increase")
    }
    
    static func onDelete() -> ApiModelDictionaryStatisticRequest {
        return ApiModelDictionaryStatisticRequest(downloads: "no_change", rating: "decrease")
    }
}
