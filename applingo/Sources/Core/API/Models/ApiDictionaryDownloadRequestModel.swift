import Foundation

struct ApiDictionaryDownloadRequestModel: Codable {
    let dictionary: String
    
    init(from dictionary: String) {
        self.dictionary = dictionary
    }
    
    func toDictionary() -> [String: Any] {
        ["identifier": dictionary, "operation": "download"]
    }
}
