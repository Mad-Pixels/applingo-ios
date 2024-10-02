import Foundation
import SQLite3


// Протокол, определяющий методы для работы с базой данных
protocol DatabaseManagerProtocol {
    func connect() throws
    func execute(query: String) throws
    func fetch<T>(query: String) throws -> [T]
}

// Класс для управления локальной базой данных SQLite
class DatabaseManager: DatabaseManagerProtocol {
    private let logger: LoggerProtocol
    private var db: OpaquePointer?
    private let dbPath: String
    
    init(dbName: String, logger: LoggerProtocol) {
        self.logger = logger
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        self.dbPath = documentsPath.appendingPathComponent(dbName).path
        logger.log("Database path: \(dbPath)", level: .info)
    }
    
    // Метод для подключения к базе данных
    func connect() throws {
        // Проверяем, существует ли файл базы данных
        if !FileManager.default.fileExists(atPath: dbPath) {
            logger.log("Database file not found. Creating new database.", level: .info)
            try createDatabase()
        }
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            throw DatabaseError.connectionError("Unable to open database.")
        }
        logger.log("Database connected successfully", level: .info)
    }
    
    private func createDatabase() throws {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            throw DatabaseError.fileCreationError("Unable to create database file.")
        }
        
        // Здесь вы можете добавить логику создания таблиц
        try initializeDatabase()
        
        logger.log("New database created and initialized", level: .info)
    }
    
    private func initializeDatabase() throws {
        // Пример создания таблицы
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        );
        """
        
        try execute(query: createTableQuery)
        logger.log("Database schema initialized", level: .info)
    }
    
    // Метод для выполнения SQL-запросов
    func execute(query: String) throws {
        var errorMessage: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, query, nil, nil, &errorMessage) != SQLITE_OK {
            let errorString = String(cString: errorMessage!)
            sqlite3_free(errorMessage)
            throw DatabaseError.queryError(errorString)
        }
    }
    
    // Метод для выборки данных из базы данных
    // Примечание: Этот метод нужно будет доработать для конкретных типов данных
    func fetch<T>(query: String) throws -> [T] {
        // TODO: Реализовать логику выборки и преобразования данных
        return []
    }
    
    deinit {
        sqlite3_close(db)
    }
}
