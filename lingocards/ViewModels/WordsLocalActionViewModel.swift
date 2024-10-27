import Foundation
import Combine

final class WordsLocalActionViewModel: BaseDatabaseViewModel {
    private let repository: WordRepositoryProtocol
    private let dictionaryRepository: DictionaryRepositoryProtocol

    init(repository: WordRepositoryProtocol) {
        self.repository = repository
        if let dbQueue = DatabaseManager.shared.databaseQueue {
            self.dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
        } else {
            fatalError("Database is not connected")
        }
    }

    func save(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.save(word) },
            successHandler: { _ in },
            errorSource: .wordSave,
            errorMessage: "Failed to save word",
            tab: .words,
            completion: completion
        )
    }

    func update(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(word) },
            successHandler: { _ in },
            errorSource: .wordUpdate,
            errorMessage: "Failed to update word",
            tab: .words,
            completion: completion
        )
    }

    func delete(_ word: WordItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(word) },
            successHandler: { _ in },
            errorSource: .wordDelete,
            errorMessage: "Failed to delete word",
            tab: .words,
            completion: completion
        )
    }
}
