import Foundation
import Combine

actor DictionaryDownload {
    static let shared = DictionaryDownload()
    
    private init() {}
    
    /// Downloads the dictionary from the API, parses it, and saves it to the local database.
    /// - Parameter dictionary: The model representing a dictionary item from the API.
    /// - Throws: Any network or parsing error that might occur.
    func download(dictionary: ApiModelDictionaryItem) async throws {
        // 1. Скачиваем файл (CSV / TSV) из сети.
        let fileURL = try await ApiManagerCache.shared.downloadDictionary(dictionary)
        
        // 2. Создаём менеджер импорта, который найдет подходящий парсер (CSV/TSV) и распарсит файл.
        let importManager = TableParserManagerImport(
            factory: TableParserFactory() // Внутри есть CSV и TSV парсеры.
        )
        
        // 3. Преобразуем ApiModelDictionaryItem в TableParserModelDictionary
        //    (здесь вы можете адаптировать поля, например, уровень словаря — level — можно положить в description).
        let dictionaryMetadata = TableParserModelDictionary(
            guid: dictionary.id,
            name: dictionary.name,
            author: dictionary.author,
            category: dictionary.category,
            subcategory: dictionary.subcategory,
            description: "\(dictionary.description) (level: \(dictionary.level))"
        )
        
        // 4. Импортируем данные (парсинг) в (dictionaryModel, words).
        let (dictionaryModel, words) = try importManager.import(
            from: fileURL,
            dictionaryMetadata: dictionaryMetadata
        )
        
        // 5. Создаём менеджер сохранения, в который передаём ваш ProcessDatabase.
        //    Предположим, что у вас где-то есть общий экземпляр ProcessDatabase.
        let saver = TableParserManagerSave(processDatabase: ProcessDatabase())
        
        // 6. Сохраняем в локальную базу данных.
        saver.saveToDatabase(dictionary: dictionaryModel, words: words)
        
        // 7. Удаляем загруженный файл, если он больше не нужен.
        try? FileManager.default.removeItem(at: fileURL)
        
        // 8. Сообщаем всем заинтересованным компонентам, что словари обновились.
        await MainActor.run {
            NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
        }
    }
}
