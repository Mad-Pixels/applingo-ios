import Foundation
import Combine
import GRDB

final class DictionaryAction: ProcessDatabase {
    private let dictionaryRepository: DatabaseManagerDictionary
    
    // Если необходимо указывать экран:
    private let screenType: ScreenType = .DictionaryLocalList
    
    // Если хотите продолжать хранить frame, можно оставлять это поле
    private var frame: ScreenType = .Home

    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }
        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        super.init()
    }

    // MARK: - CRUD

    func save(_ dictionary: DatabaseModelDictionary,
              completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.save(dictionary) },
            success: { _ in },
            screen: screenType,
            // Можно также передавать frame, если это важно в метаданных
            metadata: [
                "operation": "save",
                "dictionary": dictionary.toString(),
                "frame": frame.rawValue
            ],
            completion: completion
        )
    }

    func update(_ dictionary: DatabaseModelDictionary,
                completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.update(dictionary) },
            success: { _ in },
            screen: screenType,
            metadata: [
                "operation": "update",
                "dictionary": dictionary.toString(),
                "frame": frame.rawValue
            ],
            completion: completion
        )
    }

    func delete(_ dictionary: DatabaseModelDictionary,
                completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.delete(dictionary) },
            success: { _ in },
            screen: screenType,
            metadata: [
                "operation": "delete",
                "dictionary": dictionary.toString(),
                "frame": frame.rawValue
            ],
            completion: completion
        )
    }

    func updateStatus(dictionaryID: Int,
                      newStatus: Bool,
                      completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.dictionaryRepository.updateStatus(dictionaryID: dictionaryID, newStatus: newStatus) },
            success: { _ in },
            screen: screenType,
            metadata: [
                "operation": "updateStatus",
                "dictionaryID": "\(dictionaryID)",
                "newStatus": "\(newStatus)",
                "frame": frame.rawValue
            ],
            completion: completion
        )
    }

    // MARK: - Frame

    func setFrame(_ newFrame: ScreenType) {
        self.frame = newFrame
    }
}
