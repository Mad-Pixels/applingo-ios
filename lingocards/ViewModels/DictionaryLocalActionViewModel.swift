import Foundation
import Combine
import GRDB

final class DictionaryLocalActionViewModel: BaseDatabaseViewModel {
    private let repository: DictionaryRepositoryProtocol

    init(repository: DictionaryRepositoryProtocol) {
        self.repository = repository
    }

    func save(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.save(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionarySave,
            errorMessage: "Failed to save dictionary",
            tab: .dictionaries,
            completion: completion
        )
    }

    func update(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionaryUpdate,
            errorMessage: "Failed to update dictionary",
            tab: .dictionaries,
            completion: completion
        )
    }

    func delete(_ dictionary: DictionaryItem, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(dictionary) },
            successHandler: { _ in },
            errorSource: .dictionaryDelete,
            errorMessage: "Failed to delete dictionary",
            tab: .dictionaries,
            completion: completion
        )
    }

    func updateStatus(dictionaryID: Int, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            successHandler: { _ in },
            errorSource: .dictionaryUpdate,
            errorMessage: "Failed to update dictionary status",
            tab: .dictionaries,
            completion: completion
        )
    }
}
