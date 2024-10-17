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
            try db.create(table: DictionaryItem.databaseTableName, ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("hashId", .integer).unique()
                t.column("displayName", .text).notNull()
                t.column("tableName", .text).notNull()
                t.column("description", .text).notNull()
                t.column("category", .text).notNull()
                t.column("subcategory", .text).notNull()
                t.column("author", .text).notNull()
                t.column("createdAt", .integer).notNull()
                t.column("isPrivate", .boolean).notNull()
                t.column("isActive", .boolean).notNull()
            }
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

        // Парсим CSV файл
        let wordItems = try CSVImporter.parseCSV(at: url)

        // Генерируем уникальное имя таблицы
        let uniqueTableName = "Words_\(UUID().uuidString.replacingOccurrences(of: "-", with: "_"))"

        // Выполняем импорт в транзакции
        try dbQueue.write { db in
            do {
                // Создаем новую таблицу
                try WordItem.createTable(in: db, tableName: uniqueTableName)

                // Вставляем данные
                for var wordItem in wordItems {
                    wordItem.tableName = uniqueTableName
                    try wordItem.insert(db)
                }

                // Создаем запись в таблице Dictionary
                var dictionaryItem = DictionaryItem(
                    id: 0,
                    hashId: Int.random(in: Int.min...Int.max),
                    displayName: url.deletingPathExtension().lastPathComponent,
                    tableName: uniqueTableName,
                    description: "Imported dictionary",
                    category: "Imported",
                    subcategory: "",
                    author: "User",
                    createdAt: Int(Date().timeIntervalSince1970),
                    isPrivate: true,
                    isActive: true
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
