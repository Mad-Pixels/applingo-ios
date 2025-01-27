import Foundation
import Combine

final class WordAction: ProcessDatabase {
    private let dictionaryRepository: DatabaseManagerDictionary
    private let wordRepository: DatabaseManagerWord
    
    // В данном примере можно хранить информацию о "экране" или об источнике ошибки
    // Например, если у вас есть enum ScreenType, вы можете указать его здесь.
    private let screenType: ScreenType = .words
    
    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
        super.init()
    }

    // MARK: - CRUD операции для Word

    func save(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.save(word) },
            success: { _ in },
            screen: screenType,
            metadata: ["operation": "save", "word": word.toString()],
            completion: completion
        )
    }

    func update(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.update(word) },
            success: { _ in },
            screen: screenType,
            metadata: ["operation": "update", "word": word.toString()],
            completion: completion
        )
    }

    func delete(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.delete(word) },
            success: { _ in },
            screen: screenType,
            metadata: ["operation": "delete", "word": word.toString()],
            completion: completion
        )
    }

    // MARK: - Пример прямой обработки ошибки

    func dictionaryDisplayName(_ word: DatabaseModelWord) -> String {
        do {
            return try dictionaryRepository.fetchName(byTableName: word.dictionary)
        } catch {
            // Передаём ошибку в новый ErrorManager
            // Через базовый метод handleError(...)
            handleError(
                error,
                screen: screenType,
                metadata: [
                    "operation": "fetchDictionaryDisplayName",
                    "word": word.toString()
                ]
            )
            return ""
        }
    }
}
