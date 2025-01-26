import Foundation

struct ApiDictionaryDownloadResponseModel: Codable {
    let data: DownloadData
    
    struct DownloadData: Codable {
        let url: String
    }
}
