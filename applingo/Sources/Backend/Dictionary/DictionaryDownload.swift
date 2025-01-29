import Foundation

actor DictionaryDownload {
    static let shared = DictionaryDownload()
    
    private init() {}
    
    func download(dictionary: ApiModelDictionaryItem) async throws {
        let fileURL = try await ApiManagerCache.shared.downloadDictionary(dictionary)
        let (dictionaryModel, words) = try CSVManager.shared.parse(
            url: fileURL,
            dictionaryItem: DatabaseModelDictionary(
                guid: dictionary.id,
                name: dictionary.name,
                topic: dictionary.topic,
                author: dictionary.author,
                category: dictionary.category,
                subcategory: dictionary.subcategory,
                description: dictionary.description,
                level: DictionaryLevelType(rawValue: dictionary.level) ?? .undefined
            )
        )
        try CSVManager.shared.saveToDatabase(dictionary: dictionaryModel, words: words)
        try? FileManager.default.removeItem(at: fileURL)
        
        await MainActor.run {
            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
        }
    }
}
