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
            source: .dictionarySave,
            frame: frame,
            message: "Save dictionary failed",
            additionalInfo: ["dictionary": dictionary.toString()],
            completion: completion
        )
    }

    func update(_ dictionary: DictionaryItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.update(dictionary) },
            successHandler: { _ in },
            source: .dictionaryUpdate,
            frame: frame,
            message: "Update dictionary failed",
            additionalInfo: ["dictionary": dictionary.toString()],
            completion: completion
        )
    }

    func delete(_ dictionary: DictionaryItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.delete(dictionary) },
            successHandler: { _ in },
            source: .dictionaryDelete,
            frame: frame,
            message: "Delete dictionary failed",
            additionalInfo: ["dictionary": dictionary.toString()],
            completion: completion
        )
    }


    func updateStatus(dictionaryID: Int, newStatus: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.repository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            successHandler: { _ in },
            source: .dictionaryUpdate,
            frame: frame,
            message: "Update dictionary status failed",
            completion: completion
        )
    }

    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
