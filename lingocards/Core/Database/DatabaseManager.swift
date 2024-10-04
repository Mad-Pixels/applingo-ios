import Foundation
import GRDB

protocol DatabaseManagerProtocol {
    func connect() throws
    func fetchDictionaries() async throws -> [DatabaseDictionaryItem]
    func insertDictionaryItem(_ item: DatabaseDictionaryItem) async throws
    func deleteDictionaryItem(_ item: DatabaseDictionaryItem) async throws
    func createDataTable(forDictionary item: DatabaseDictionaryItem) async throws
    func dropDataTable(forDictionary item: DatabaseDictionaryItem) async throws
    func fetchDataItems(inTable tableName: String) async throws -> [DataItem]
    func insertDataItem(_ item: DataItem, intoTable tableName: String) async throws
    func updateDataItem(_ item: DataItem, inTable tableName: String) async throws
    func deleteDataItem(_ item: DataItem, fromTable tableName: String) async throws
    func execute<T>(_ block: @escaping (Database) throws -> T) async throws -> T
    func insertDataItems(_ items: [DataItem], intoTable tableName: String) async throws // Новый метод

}


class DatabaseManager: DatabaseManagerProtocol {
    private var dbQueue: DatabaseQueue?
    private let dbName: String
    private let logger: LoggerProtocol
    
    init(dbName: String, logger: LoggerProtocol) {
        self.dbName = dbName
        self.logger = logger
    }
    
    func insertDataItems(_ items: [DataItem], intoTable tableName: String) async throws {
            guard let dbQueue = dbQueue else {
                throw DatabaseError.connectionError("Database not connected")
            }
            
            try await dbQueue.write { db in
                for item in items {
                    try db.execute(
                        sql: """
                        INSERT INTO \(tableName) (hashId, frontText, backText, description, hint, createdAt, salt, success, fail, weight)
                        VALUES (:hashId, :frontText, :backText, :description, :hint, :createdAt, :salt, :success, :fail, :weight)
                        """,
                        arguments: [
                            "hashId": item.hashId,
                            "frontText": item.frontText,
                            "backText": item.backText,
                            "description": item.description ?? NSNull(),
                            "hint": item.hint ?? NSNull(),
                            "createdAt": item.createdAt,
                            "salt": item.salt,
                            "success": item.success,
                            "fail": item.fail,
                            "weight": item.weight
                        ]
                    )
                }
            }
            
            logger.log("Inserted \(items.count) items into table \(tableName)", level: .info, details: nil)
        }
    
    // Подключение к базе данных и выполнение миграций
    func connect() throws {
        let databaseURL = try FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent(dbName)
        
        var config = Configuration()
        config.readonly = false
        config.foreignKeysEnabled = true
        
        dbQueue = try DatabaseQueue(path: databaseURL.path, configuration: config)
        
        logger.log("Database path: \(databaseURL.path)", level: .info, details: nil)
        
        // Проверка и запуск миграций
        if let dbQueue = dbQueue {
            logger.log("Starting migrations", level: .info, details: nil)
            try migrator.migrate(dbQueue)
            logger.log("Migrations completed", level: .info, details: nil)
        } else {
            logger.log("Failed to connect to the database", level: .error, details: nil)
            throw DatabaseError.connectionError("Database not connected")
        }
    }
    
    // Миграции базы данных
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try db.create(table: DatabaseDictionaryItem.databaseTableName, ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("hashId", .integer).unique()
                t.column("displayName", .text).notNull()
                t.column("tableName", .text).notNull()
                t.column("description", .text).notNull()
                t.column("category", .text).notNull()
                t.column("author", .text).notNull()
                t.column("createdAt", .integer).notNull()
                t.column("isPrivate", .boolean).notNull()
                t.column("isActive", .boolean).notNull()
                // Добавьте другие столбцы по необходимости
            }
        }
        self.logger.log("Migrations registered", level: .info, details: nil)
        
        // Здесь вы можете добавить другие миграции для дополнительных таблиц
        
        return migrator
    }
    
    // MARK: - Работа с Dictionary

    func fetchDictionaries() async throws -> [DatabaseDictionaryItem] {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        return try await dbQueue.read { db in
            try DatabaseDictionaryItem.fetchAll(db)
        }
    }
    
    func insertDictionaryItem(_ item: DatabaseDictionaryItem) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try item.insert(db)
        }
        logger.log("Dictionary item inserted", level: .info, details: nil)
    }
    
    func deleteDictionaryItem(_ item: DatabaseDictionaryItem) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try item.delete(db)
        }
    }
    
    // Создание таблицы для словаря
    func createDataTable(forDictionary item: DatabaseDictionaryItem) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try db.create(table: item.tableName, ifNotExists: true) { t in
                t.autoIncrementedPrimaryKey("id")
                t.column("hashId", .integer).unique()
                t.column("frontText", .text).notNull()
                t.column("backText", .text).notNull()
                t.column("description", .text)
                t.column("hint", .text)
                t.column("createdAt", .integer).notNull()
                t.column("salt", .integer).notNull()
                t.column("success", .integer).notNull().defaults(to: 0)
                t.column("fail", .integer).notNull().defaults(to: 0)
                t.column("weight", .integer).notNull().defaults(to: 0)
                // Добавьте другие столбцы по необходимости
            }
        }
        logger.log("Table \(item.tableName) created", level: .info, details: nil)
    }
    
    // Удаление таблицы словаря
    func dropDataTable(forDictionary item: DatabaseDictionaryItem) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try db.drop(table: item.tableName)
        }
    }
    
    // MARK: - Работа с DataItem
    
    func fetchDataItems(inTable tableName: String) async throws -> [DataItem] {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        return try await dbQueue.read { db in
            let sql = "SELECT * FROM \(tableName)"
            return try DataItem.fetchAll(db, sql: sql)
        }
    }
    
    func insertDataItem(_ item: DataItem, intoTable tableName: String) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            // Используем вставку с указанием таблицы
            try db.execute(
                sql: """
                INSERT INTO \(tableName) (hashId, frontText, backText, description, hint, createdAt, salt, success, fail, weight)
                VALUES (:hashId, :frontText, :backText, :description, :hint, :createdAt, :salt, :success, :fail, :weight)
                """,
                arguments: [
                    "hashId": item.hashId,
                    "frontText": item.frontText,
                    "backText": item.backText,
                    "description": item.description ?? NSNull(),
                    "hint": item.hint ?? NSNull(),
                    "createdAt": item.createdAt,
                    "salt": item.salt,
                    "success": item.success,
                    "fail": item.fail,
                    "weight": item.weight
                ]
            )
        }
    }
    
    func updateDataItem(_ item: DataItem, inTable tableName: String) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try db.execute(
                sql: """
                UPDATE \(tableName)
                SET frontText = :frontText, backText = :backText, description = :description, hint = :hint,
                    success = :success, fail = :fail, weight = :weight
                WHERE hashId = :hashId
                """,
                arguments: [
                    "frontText": item.frontText,
                    "backText": item.backText,
                    "description": item.description ?? NSNull(),
                    "hint": item.hint ?? NSNull(),
                    "success": item.success,
                    "fail": item.fail,
                    "weight": item.weight,
                    "hashId": item.hashId
                ]
            )
        }
    }
    
    func deleteDataItem(_ item: DataItem, fromTable tableName: String) async throws {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        try await dbQueue.write { db in
            try db.execute(
                sql: "DELETE FROM \(tableName) WHERE hashId = :hashId",
                arguments: ["hashId": item.hashId]
            )
        }
    }
    
    // MARK: - Общие методы
    
    func execute<T>(_ block: @escaping (Database) throws -> T) async throws -> T {
        guard let dbQueue = dbQueue else {
            throw DatabaseError.connectionError("Database not connected")
        }
        return try await dbQueue.write { db in
            return try block(db)
        }
    }
}
