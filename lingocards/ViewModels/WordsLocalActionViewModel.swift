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
            errorSource: .wordSave,
            errorMessage: "Failed save word",
            frame: frame,
            completion: completion
        )
    }

    func update(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(word) },
            successHandler: { _ in },
            errorSource: .wordUpdate,
            errorMessage: "Failed update word",
            frame: frame,
            completion: completion
        )
    }

    func delete(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(word) },
            successHandler: { _ in },
            errorSource: .wordDelete,
            errorMessage: "Failed delete word",
            frame: frame,
            completion: completion
        )
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
