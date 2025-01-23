import Foundation
import Combine
import GRDB

final class DictionaryLocalActionViewModel: BaseDatabaseViewModel {
    private let dictionaryRepository: DictionaryRepositoryProtocol
    private var frame: AppFrameModel = .main

    override init() {
        if let dbQueue = AppDatabase.shared.databaseQueue {
            self.dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
        } else {
            fatalError("Database is not connected")
        }
        super.init()
    }

    func save(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.save(dictionary) },
            successHandler: { _ in },
            source: .dictionarySave,
            frame: frame,
            message: "Save dictionary failed",
            additionalInfo: ["dictionary": dictionary.toString()],
            completion: completion
        )
    }
    
    

    func update(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.update(dictionary) },
            successHandler: { _ in },
            source: .dictionaryUpdate,
            frame: frame,
            message: "Update dictionary failed",
            additionalInfo: ["dictionary": dictionary.toString()],
            completion: completion
        )
    }

    func delete(_ dictionary: DatabaseModelDictionary, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.delete(dictionary) },
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
            { try self.dictionaryRepository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
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
