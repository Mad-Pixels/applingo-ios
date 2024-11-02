import Foundation
import Combine
import GRDB

final class DictionaryLocalActionViewModel: BaseDatabaseViewModel {
    private var frame: AppFrameModel = .main
    private let repository: DictionaryRepositoryProtocol

    init(repository: DictionaryRepositoryProtocol) {
        self.repository = repository
    }

    func save(_ dictionary: DictionaryItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.save(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionarySave,
            errorMessage: "Failed to save dictionary",
            frame: frame,
            completion: completion
        )
    }

    func update(_ dictionary: DictionaryItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionaryUpdate,
            errorMessage: "Failed to update dictionary",
            frame: frame,
            completion: completion
        )
    }

    func delete(_ dictionary: DictionaryItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionaryDelete,
            errorMessage: "Failed to delete dictionary",
            frame: frame,
            completion: completion
        )
    }

    func updateStatus(dictionaryID: Int, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            successHandler: { _ in },
            errorSource: .dictionaryUpdate,
            errorMessage: "Failed to update dictionary status",
            frame: frame,
            completion: completion
        )
    }
    
    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
