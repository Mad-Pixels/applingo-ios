import Foundation
import GRDB
import Combine

class DatabaseManager: ObservableObject {
    // Singleton
    static let shared = DatabaseManager(dbName: "LingocardDB.sqlite")

    @Published private(set) var isConnected: Bool = false
    private var dbQueue: DatabaseQueue?
    private let dbName: String
    private var databaseURL: URL?

    // Приватный инициализатор для Singleton
    private init(dbName: String) {
        self.dbName = dbName
    }
    
    // Подключение к базе данных
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
                Logger.debug("[Database]: Connected and migration completed.")
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
    
    // Миграции базы данных
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
    
    // Отключение от базы данных
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[Database]: Disconnected.")
    }
    
    // Получение доступа к очереди базы данных
    var databaseQueue: DatabaseQueue? {
        return dbQueue
    }
}
