import Foundation
import Combine

final class WordsLocalActionViewModel: BaseDatabaseViewModel {
    private let dictionaryRepository: DictionaryRepositoryProtocol
    private let wordRepository: WordRepositoryProtocol
    private var frame: AppFrameModel = .main

    override init() {
        if let dbQueue = AppDatabase.shared.databaseQueue {
            self.dictionaryRepository = RepositoryDictionary(dbQueue: dbQueue)
            self.wordRepository = RepositoryWord(dbQueue: dbQueue)
        } else {
            fatalError("Database is not connected")
        }
    }
    
    func save(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
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

    func update(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
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

    
    func delete(_ word: WordItemModel, completion: @escaping (Result<Void, Error>) -> Void) {
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
    
    func dictionaryDisplayName(_ word: WordItemModel) -> String {
        do {
            return try self.dictionaryRepository.fetchDisplayName(byTableName: word.tableName)
        } catch {
            let appError = AppErrorModel(
                type: .database,
                message: "Failed to fetch dictionary display name for tableName \(word.tableName)",
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
