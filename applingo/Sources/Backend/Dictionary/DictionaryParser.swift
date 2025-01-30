import Foundation

/// A class responsible for handling dictionary import operations.
final class DictionaryParser: ProcessDatabase {
    private let screenType: ScreenType = .DictionaryLocalList
    
    /// Imports a dictionary from a given URL.
    /// - Parameters:
    ///   - url: The URL of the file to import.
    ///   - completion: Closure called after import completion.
    func importDictionary(from url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        Logger.debug("[Import]: Starting dictionary import", metadata: [
            "url": url.absoluteString
        ])
        
        // Выполняем импорт в фоновом потоке
        performDatabaseOperation(
            {
                // 1. Открываем security-scoped доступ
                guard url.startAccessingSecurityScopedResource() else {
                    Logger.debug("[Import]: Failed to startAccessingSecurityScopedResource", metadata: [
                        "url": url.absoluteString
                    ])
                    throw ImportError.fileAccessDenied
                }
                defer {
                    // Закрываем ресурс по выходе
                    url.stopAccessingSecurityScopedResource()
                }
                
                // 2. Импортируем (парсим) данные с помощью TableParserManagerImport
                let importManager = TableParserManagerImport()
                let (dictionaryModel, words) = try importManager.import(from: url)
                
                // 3. Сохраняем в БД (TableParserManagerSave)
                let saveManager = TableParserManagerSave(processDatabase: self)
                saveManager.saveToDatabase(dictionary: dictionaryModel, words: words)
                
                // 4. (Опционально) Удаляем файл
                // try? FileManager.default.removeItem(at: url)
            },
            success: { _ in
                NotificationCenter.default.post(name: .dictionaryListShouldUpdate, object: nil)
            },
            screen: screenType,
            metadata: [
                "operation": "import",
                "url": url.absoluteString
            ],
            completion: completion
        )
    }
}

// MARK: - Import Error

extension DictionaryParser {
    enum ImportError: LocalizedError {
        case fileAccessDenied
        
        var errorDescription: String? {
            switch self {
            case .fileAccessDenied:
                return LocaleManager.shared.localizedString(for: "ErrFileAccess")
            }
        }
    }
}
