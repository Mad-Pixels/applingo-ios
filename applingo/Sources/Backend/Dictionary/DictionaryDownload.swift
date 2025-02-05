import Foundation
import Combine

/// Actor responsible for downloading dictionaries from the API
/// and delegating the parsing & saving to the DictionaryParser.
///
/// This actor handles the complete workflow:
/// 1. Downloads the dictionary file from the API.
/// 2. Creates dictionary metadata from the API model (ensuring the proper formation of the dictionary object).
/// 3. Delegates parsing & saving to the DictionaryParser.
/// 4. Cleans up the temporary file.
/// 5. Notifies observers about the update.
actor DictionaryDownload {
    static let shared = DictionaryDownload()
    
    // MARK: - Public Methods
    
    /// Downloads the dictionary from the API, parses its contents, and saves the result to the local database.
    ///
    /// - Parameter dictionary: The API model representing the dictionary.
    /// - Throws: An error if any network, parsing, or database operation fails.
    func download(dictionary: ApiModelDictionaryItem) async throws {
        Logger.debug(
            "[Download]: Starting dictionary download",
            metadata: [
                "dictionaryId": dictionary.id,
                "dictionaryName": dictionary.name
            ]
        )
        
        let fileURL = try await ApiManagerCache.shared.downloadDictionary(dictionary)
        Logger.debug(
            "[Download]: File downloaded successfully",
            metadata: [
                "fileURL": fileURL.absoluteString
            ]
        )
        
        defer {
            cleanupDownloadedFile(at: fileURL)
        }
        
        let dictionaryMetadata = createDictionaryMetadata(from: dictionary)
        Logger.debug(
            "[Download]: Created dictionary metadata",
            metadata: [
                "guid": dictionaryMetadata.guid,
                "name": dictionaryMetadata.name
            ]
        )
        
        let parser = DictionaryParser()
        try await withCheckedThrowingContinuation { continuation in
            parser.importDictionary(from: fileURL, dictionaryMetadata: dictionaryMetadata) { result in
                continuation.resume(with: result)
            }
        }
        Logger.debug(
            "[Download]: Successfully imported dictionary using parser",
            metadata: [
                "dictionaryId": dictionaryMetadata.guid
            ]
        )
        
        await notifyDictionaryUpdate()
        Logger.debug(
            "[Download]: Dictionary processing completed",
            metadata: [
                "dictionaryId": dictionary.id
            ]
        )
    }
    
    // MARK: - Private Methods
    
    /// Creates dictionary metadata from the given API model.
    ///
    /// This method extracts necessary fields from the API model to create a
    /// `ParserModelDictionary` used for further processing.
    ///
    /// - Parameter dictionary: The API model representing the dictionary.
    /// - Returns: A `ParserModelDictionary` instance with populated metadata.
    private func createDictionaryMetadata(from dictionary: ApiModelDictionaryItem) -> ParserModelDictionary {
        let level = DictionaryLevelType(rawValue: dictionary.level) ?? .undefined
        
        if level == .undefined {
            Logger.warning(
                "[Download]: Undefined dictionary level",
                metadata: [
                    "dictionaryId": dictionary.id,
                    "providedLevel": dictionary.level
                ]
            )
        }
        
        return ParserModelDictionary(
            guid: dictionary.id,
            name: dictionary.name,
            topic: dictionary.topic,
            author: dictionary.author,
            category: dictionary.category,
            subcategory: dictionary.subcategory,
            description: dictionary.description,
            level: level,
            isLocal: false
        )
    }
    
    /// Cleans up the downloaded temporary file.
    ///
    /// This method removes the temporary file from the file system after the dictionary
    /// has been processed and saved to the database.
    ///
    /// - Parameter fileURL: The URL of the temporary file to remove.
    private func cleanupDownloadedFile(at fileURL: URL) {
        do {
            try FileManager.default.removeItem(at: fileURL)
            Logger.debug(
                "[Download]: Cleaned up temporary file",
                metadata: [
                    "fileURL": fileURL.absoluteString
                ]
            )
        } catch {
            Logger.warning(
                "[Download]: Failed to clean up temporary file",
                metadata: [
                    "fileURL": fileURL.absoluteString,
                    "error": error.localizedDescription
                ]
            )
        }
    }
    
    /// Notifies observers about an update to the dictionary list.
    ///
    /// This method posts a notification on the main actor, allowing UI components and other parts
    /// of the application to refresh their data based on the update.
    private func notifyDictionaryUpdate() async {
        await MainActor.run {
            Logger.debug("[Download]: Notifying about dictionary update")
            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
        }
    }
}
