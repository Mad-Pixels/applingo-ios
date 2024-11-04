import Foundation
import Combine

final class WordsLocalActionViewModel: BaseDatabaseViewModel {
    private var frame: AppFrameModel = .main
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
    
    func save(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.save(word) },
            successHandler: { _ in },
            source: .wordSave,
            frame: frame,
            message: "Failed to save word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    func update(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(word) },
            successHandler: { _ in },
            source: .wordUpdate,
            frame: frame,
            message: "Failed to update word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    
    func delete(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(word) },
            successHandler: { _ in },
            source: .wordDelete,
            frame: frame,
            message: "Failed to delete word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
