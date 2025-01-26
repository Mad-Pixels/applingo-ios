import Foundation
import Combine

final class WordsLocalActionViewModel: BaseDatabaseViewModel {
    private let dictionaryRepository: DatabaseManagerDictionary
    private let wordRepository: DatabaseManagerWord
    private var frame: AppFrameModel = .main

    override init() {
        guard let dbQueue = AppDatabase.shared.databaseQueue else {
            fatalError("Database is not connected")
        }

        self.dictionaryRepository = DatabaseManagerDictionary(dbQueue: dbQueue)
        self.wordRepository = DatabaseManagerWord(dbQueue: dbQueue)
    }

    func save(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.save(word) },
            successHandler: { _ in },
            source: .wordSave,
            frame: frame,
            message: "Failed to save word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    func update(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.update(word) },
            successHandler: { _ in },
            source: .wordUpdate,
            frame: frame,
            message: "Failed to update word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    func delete(_ word: DatabaseModelWord, completion: @escaping (Result<Void, Error>) -> Void) {
        performDatabaseOperation(
            { try self.wordRepository.delete(word) },
            successHandler: { _ in },
            source: .wordDelete,
            frame: frame,
            message: "Failed to delete word",
            additionalInfo: ["word": word.toString()],
            completion: completion
        )
    }

    func dictionaryDisplayName(_ word: DatabaseModelWord) -> String {
        do {
            return try self.dictionaryRepository.fetchName(byTableName: word.dictionary)
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: "Failed to fetch dictionary display name for tableName \(word.dictionary)",
                localized: LanguageManager.shared.localizedString(for: "ErrDatabaseDefault"),
                original: error,
                additional: ["word": word.toString()]
            )
            ErrorManager1.shared.setError(
                appError: appError,
                frame: frame,
                source: .dictionaryDisplayName
            )
            return ""
        }
    }

    func setFrame(_ newFrame: AppFrameModel) {
        self.frame = newFrame
    }
}
