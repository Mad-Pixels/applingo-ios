import Foundation
import GRDB
import Combine

class DatabaseManager: ObservableObject {
    static let shared = DatabaseManager()
    
    @Published private(set) var isConnected: Bool = false
    private var dbQueue: DatabaseQueue?
    private let dbName = "LingocardDB.sqlite"
    private var databaseURL: URL?

    private init() {}
    
    func connect() throws {
        guard dbQueue == nil else {
            Logger.debug("[Database]: Already connected")
            return
        }
        
        databaseURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(dbName)

        var config = Configuration()
        config.foreignKeysEnabled = true
        config.readonly = false
        
        do {
            dbQueue = try DatabaseQueue(path: databaseURL!.path, configuration: config)
            
            if let dbQueue = dbQueue {
                Logger.debug("[Database]: Migration started")
                // Применяем миграции перед подключением
                try migrator.migrate(dbQueue)
                isConnected = true
            }
        } catch {
            let appError = AppError(
                errorType: .database,
                errorMessage: "[Database]: Connection failed",
                additionalInfo: ["path": "\(databaseURL!.path)", "error": "\(error.localizedDescription)"]
            )
            ErrorManager.shared.setError(appError: appError, tab: .main, source: .initialization)
            throw appError
        }
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        migrator.registerMigration("createDictionary") { db in
            try DictionaryItem.createTable(in: db)
            Logger.debug("[Database]: Dictionary table created successfully")
        }
        return migrator
    }
    
    var databaseQueue: DatabaseQueue? {
        return dbQueue
    }
    
    func importCSVFile(at url: URL) throws {
        guard isConnected, let dbQueue = dbQueue else {
            throw AppError(
                errorType: .database,
                errorMessage: "[Database]: Not connected",
                additionalInfo: nil
            )
        }

        let uniqueTableName = "Words_\(UUID().uuidString.replacingOccurrences(of: "-", with: "_"))"

        // Парсим CSV файл
        let wordItems = try CSVImporter.parseCSV(at: url, tableName: uniqueTableName)

        // Выполняем импорт в транзакции
        try dbQueue.write { db in
            do {
                // Создаем таблицу для слов, если она не существует
                try WordItem.createTable(in: db, tableName: uniqueTableName)

                // Вставляем данные
                for var wordItem in wordItems {
                    wordItem.tableName = uniqueTableName
                    try wordItem.insert(db)
                }

                // Создаем запись в таблице Dictionary
                var dictionaryItem = DictionaryItem(
                    displayName: url.deletingPathExtension().lastPathComponent,
                    tableName: uniqueTableName,
                    description: "Imported dictionary",
                    category: "Imported",
                    subcategory: "",
                    author: "User"
                )
                try dictionaryItem.insert(db)
                Logger.debug("[Database]: CSV file imported successfully")
            } catch {
                throw error  // В случае ошибки транзакция отменяется
            }
        }
    }
    
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[Database]: Disconnected.")
    }
}
