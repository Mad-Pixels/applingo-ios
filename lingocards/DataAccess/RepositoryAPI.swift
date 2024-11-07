import Foundation
import GRDB

class RepositoryAPI: APIRepositoryProtocol {
    private let apiManager: APIManager
    private let databaseManager: DatabaseManager
    
    init(apiManager: APIManager = APIManager.shared, databaseManager: DatabaseManager = DatabaseManager.shared) {
            self.apiManager = apiManager
            self.databaseManager = databaseManager
        }
    
    func getCategories() async throws -> CategoryItemModel {
        let endpoint = "/device/v1/category/query"
        let body = "{}".data(using: .utf8)
        let method: HTTPMethod = .post
        
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(ApiCategoryResponseModel.self, from: data)
        Logger.debug("[RepositoryAPI]: getCategories - fetched")
        return response.data
    }
    
    func getDictionaries(request: DictionaryQueryRequest? = nil) async throws -> (dictionaries: [DictionaryItemModel], lastEvaluated: String?) {
        let endpoint = "/device/v1/dictionary/query"
        let body = try? JSONSerialization.data(withJSONObject: request?.toDictionary() ?? [:])
        let method: HTTPMethod = .post
            
        let data = try await apiManager.request(
            endpoint: endpoint,
            method: method,
            body: body
        )
        let response = try JSONDecoder().decode(ApiDictionaryResponseModel.self, from: data)

        let dictionaries = response.data.items.map { dictionaryItem in
            DictionaryItemModel(
                id: UUID().hashValue,
                displayName: dictionaryItem.name,
                tableName: dictionaryItem.dictionary,
                description: dictionaryItem.description,
                category: dictionaryItem.category,
                subcategory: dictionaryItem.subcategory,
                author: dictionaryItem.author,
                createdAt: dictionaryItem.createdAt,
                isPublic: (dictionaryItem.isPublic != 0)
            )
        }
        return (dictionaries: dictionaries, lastEvaluated: response.data.lastEvaluated)
    }
    
    func downloadDictionary(_ dictionary: DictionaryItemModel) async throws {
            guard let dbQueue = databaseManager.databaseQueue else {
                throw DatabaseError.connectionNotEstablished
            }
            
            // Очищаем tableName от расширения файла
            let cleanTableName = dictionary.tableName.replacingOccurrences(of: ".csv", with: "")
            var dictionaryToSave = dictionary
            dictionaryToSave.tableName = cleanTableName
            
            // Проверяем существующие словари
            try await dbQueue.read { db in
                let existingDictionaries = try DictionaryItemModel.fetchAll(db)
                Logger.debug("[RepositoryAPI]: Existing dictionaries: \(existingDictionaries.map { "\($0.tableName) (active: \($0.isActive))" })")
            }
            
            // 1. Получаем pre-signed URL
            let endpoint = "/device/v1/dictionary/download_url"
            let downloadRequest = DictionaryDownloadRequest(dictionary: dictionary.tableName)
            let body = try? JSONSerialization.data(withJSONObject: downloadRequest.toDictionary())
            
            let data = try await apiManager.request(
                endpoint: endpoint,
                method: .post,
                body: body
            )
            
            let response = try JSONDecoder().decode(ApiDownloadResponseModel.self, from: data)
            Logger.debug("[RepositoryAPI]: Got pre-signed URL for dictionary: \(cleanTableName)")
            
            // 2. Скачиваем CSV файл
            guard let url = URL(string: response.data.url) else {
                throw APIError.invalidEndpointURL(endpoint: response.data.url)
            }
            
            let (localURL, urlResponse) = try await URLSession.shared.download(from: url)
            
            // Проверяем HTTP статус
            if let httpResponse = urlResponse as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            // Проверяем содержимое файла
            let content = try String(contentsOf: localURL, encoding: .utf8)
            
            // Проверяем на ошибки S3
            if content.contains("<Error>") {
                if content.contains("NoSuchBucket") {
                    throw APIError.s3Error(message: "S3 bucket does not exist")
                } else if content.contains("AccessDenied") {
                    throw APIError.s3Error(message: "Access denied to S3 bucket")
                } else if content.contains("NoSuchKey") {
                    throw APIError.s3Error(message: "File not found in S3 bucket")
                } else {
                    throw APIError.s3Error(message: "Unknown S3 error")
                }
            }
            
            // Проверяем базовую структуру CSV
            if content.isEmpty {
                throw APIError.invalidCSVFormat(message: "File is empty")
            }
            
            let firstLine = content.components(separatedBy: .newlines).first ?? ""
            if firstLine.components(separatedBy: ",").count < 2 {
                throw APIError.invalidCSVFormat(message: "File must contain at least 2 columns")
            }
            
            Logger.debug("[RepositoryAPI]: Downloaded CSV file for dictionary: \(cleanTableName)")
            Logger.debug("[RepositoryAPI]: CSV preview: \(String(content.prefix(200)))")
            
            do {
                // Парсим CSV и получаем слова
                let wordItems = try CSVImporter.parseCSV(at: localURL, tableName: cleanTableName)
                
                // Проверяем, что есть слова
                guard !wordItems.isEmpty else {
                    throw APIError.emptyDictionary
                }
                
                Logger.debug("[RepositoryAPI]: Parsed words sample (first 3): \(wordItems.prefix(3).map { "\($0.frontText) - \($0.backText)" })")
                Logger.debug("[RepositoryAPI]: Total parsed words: \(wordItems.count)")
                
                // Записываем в базу данных словарь и слова
                try await dbQueue.write { db in
                    // Проверяем существование словаря
                    let existingDictionary = try DictionaryItemModel
                        .filter(Column("tableName") == cleanTableName)
                        .fetchOne(db)
                    
                    if let existing = existingDictionary {
                        Logger.debug("[RepositoryAPI]: Updating existing dictionary: \(existing.toString())")
                        dictionaryToSave.id = existing.id
                        try dictionaryToSave.update(db)
                    } else {
                        Logger.debug("[RepositoryAPI]: Creating new dictionary")
                        try dictionaryToSave.insert(db)
                    }
                    
                    // Удаляем существующие слова
                    let deletedCount = try WordItemModel
                        .filter(Column("tableName") == cleanTableName)
                        .deleteAll(db)
                    Logger.debug("[RepositoryAPI]: Deleted \(deletedCount) existing words")
                    
                    // Добавляем новые слова
                    var insertedCount = 0
                    for var wordItem in wordItems {
                        wordItem.tableName = cleanTableName
                        try wordItem.insert(db)
                        insertedCount += 1
                        
                        if insertedCount % 100 == 0 {
                            Logger.debug("[RepositoryAPI]: Inserted \(insertedCount) words...")
                        }
                    }
                    
                    Logger.debug("[RepositoryAPI]: Completed inserting \(insertedCount) words")
                }
                
                // Финальная проверка
                try await dbQueue.read { db in
                    let dictionary = try DictionaryItemModel
                        .filter(Column("tableName") == cleanTableName)
                        .fetchOne(db)
                        
                    let wordCount = try WordItemModel
                        .filter(Column("tableName") == cleanTableName)
                        .fetchCount(db)
                    
                    Logger.debug("[RepositoryAPI]: Final state - Dictionary: \(dictionary?.toString() ?? "not found"), Words count: \(wordCount)")
                    
                    // Проверяем соответствие количества слов
                    guard wordCount == wordItems.count else {
                        throw APIError.apiErrorMessage(
                            message: "Word count mismatch after import",
                            statusCode: 500
                        )
                    }
                }
                
            } catch {
                print("[RepositoryAPI]: Import failed - \(error.localizedDescription)")
                // Очищаем данные при ошибке
                try? await dbQueue.write { db in
                    try WordItemModel
                        .filter(Column("tableName") == cleanTableName)
                        .deleteAll(db)
                    try dictionaryToSave.delete(db)
                }
                throw error
            }
            
            // Удаляем временный файл
            try? FileManager.default.removeItem(at: localURL)
        }
}
