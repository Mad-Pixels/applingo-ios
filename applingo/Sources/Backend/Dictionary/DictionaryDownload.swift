import Foundation
import Combine

/// Actor responsible for downloading and processing dictionaries.
/// Handles the complete flow from downloading to saving in the database.
actor DictionaryDownload {
    static let shared = DictionaryDownload()
    
    // MARK: - Private Properties
    private var screen: ScreenType = .Home
    
    init() {
        Logger.info("[Dictionary]: Initialized singleton instance")
    }
    
    // MARK: - Public Methods
    
    /// Sets the current screen type for operation tracking
    /// - Parameter screen: The screen type to set
    func setFrame(_ screen: ScreenType) {
        Logger.debug(
            "[Dictionary]: Setting frame",
            metadata: [
                "oldFrame": self.screen.rawValue,
                "newFrame": screen.rawValue
            ]
        )
        self.screen = screen
    }
    
    /// Downloads the dictionary from the API, parses it, and saves it to the local database.
    /// - Parameter dictionary: The model representing a dictionary item from the API.
    /// - Throws: Any network or parsing error that might occur.
    func download(dictionary: ApiModelDictionaryItem) async throws {
        Logger.info(
            "[Dictionary]: Starting dictionary download",
            metadata: [
                "dictionaryId": dictionary.id,
                "dictionaryName": dictionary.name
            ]
        )
        
        Logger.debug("[Dictionary]: Downloading dictionary file")
        let fileURL = try await ApiManagerCache.shared.downloadDictionary(dictionary)
        
        Logger.info(
            "[Dictionary]: File downloaded successfully",
            metadata: ["fileURL": fileURL.absoluteString]
        )
        let importManager = TableParserManagerImport(
            factory: TableParserFactory()
        )
        
        let dictionaryMetadata = createDictionaryMetadata(from: dictionary)
        Logger.debug(
            "[Dictionary]: Created dictionary metadata",
            metadata: [
                "guid": dictionaryMetadata.guid,
                "name": dictionaryMetadata.name
            ]
        )
        
        Logger.debug("[Dictionary]: Starting file parsing")
        let (dictionaryModel, words) = try importManager.import(
            from: fileURL,
            dictionaryMetadata: dictionaryMetadata
        )
        Logger.info(
            "[Dictionary]: Parsing completed",
            metadata: [
                "dictionaryId": dictionaryModel.guid,
                "wordsCount": String(words.count)
            ]
        )
        
        let saver = TableParserManagerSave(processDatabase: ProcessDatabase())
        Logger.debug("[Dictionary]: Saving to database")
        
        saver.saveToDatabase(dictionary: dictionaryModel, words: words)
        Logger.info(
            "[Dictionary]: Successfully saved to database",
            metadata: [
                "dictionaryId": dictionaryModel.guid,
                "wordsCount": String(words.count)
            ]
        )
        
        cleanupDownloadedFile(at: fileURL)
        await notifyDictionaryUpdate()
        
        Logger.info(
            "[Dictionary]: Dictionary processing completed",
            metadata: ["dictionaryId": dictionary.id]
        )
    }
    
    /// Creates dictionary metadata from API model
    private func createDictionaryMetadata(from dictionary: ApiModelDictionaryItem) -> TableParserModelDictionary {
        let level = DictionaryLevelType(rawValue: dictionary.level) ?? .undefined
        
        if level == .undefined {
            Logger.warning(
                "[Dictionary]: Undefined dictionary level",
                metadata: [
                    "dictionaryId": dictionary.id,
                    "providedLevel": dictionary.level
                ]
            )
        }
        
        return TableParserModelDictionary(
            guid: dictionary.id,
            name: dictionary.name,
            topic: dictionary.topic,
            author: dictionary.author,
            category: dictionary.category,
            subcategory: dictionary.subcategory,
            description: dictionary.description,
            level: level
        )
    }
    
    /// Cleans up the downloaded file
    private func cleanupDownloadedFile(at fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            Logger.debug(
                "[Dictionary]: Cleaned up temporary file",
                metadata: ["fileURL": fileURL.absoluteString]
            )
        } catch {
            Logger.warning(
                "[Dictionary]: Failed to clean up temporary file",
                metadata: [
                    "fileURL": fileURL.absoluteString,
                    "error": error.localizedDescription
                ]
            )
        }
    }
    
    /// Notifies observers about dictionary update
    private func notifyDictionaryUpdate() async {
        await MainActor.run {
            Logger.debug("[Dictionary]: Notifying about dictionary update")
            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
        }
    }
}
