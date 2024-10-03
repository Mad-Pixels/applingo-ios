import Foundation
import SQLite3

protocol DatabaseManagerProtocol {
    func fetch<T>(query: String) throws -> [T]
    func execute(query: String) throws
    func connect() throws
}

class DatabaseManager: DatabaseManagerProtocol {
    private let logger: LoggerProtocol
    private var db: OpaquePointer?
    private let dbPath: String
    
    init(dbName: String, logger: any LoggerProtocol) {
        self.dbPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dbName).path
        self.logger = logger
    }
    
    func connect() throws {
        if !FileManager.default.fileExists(atPath: dbPath) {
            logger.log("Database file not found. Creating new database.", level: .info, details: nil)
            try createDatabase()
        }
        
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            throw DatabaseError.connectionError("Unable to open database.")
        }
    }
    
    private func createDatabase() throws {
        if sqlite3_open(dbPath, &db) != SQLITE_OK {
            throw DatabaseError.fileCreationError("Unable to create database file.")
        }
        
        try initializeDatabase()
        logger.log("New database created and initialized", level: .info, details: nil)
    }
    
    private func initializeDatabase() throws {
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        );
        """
        
        try execute(query: createTableQuery)
        logger.log("Database schema initialized", level: .info, details: nil)
    }
    
    // Метод для выполнения SQL-запросов
    func execute(query: String) throws {
        var errorMessage: UnsafeMutablePointer<Int8>?
        if sqlite3_exec(db, query, nil, nil, &errorMessage) != SQLITE_OK {
            let errorString = String(cString: errorMessage!)
            
            if let errorMessage = errorMessage {
                let errorString = String(cString: errorMessage)
                sqlite3_free(errorMessage)
                throw DatabaseError.queryError(errorString)
            } else {
                throw DatabaseError.queryError("Unknown error")
            }
        }
    }
    
    // Метод для выборки данных из базы данных
    // Примечание: Этот метод нужно будет доработать для конкретных типов данных
    func fetch<T>(query: String) throws -> [T] {
        return []
    }
    
    deinit {
        sqlite3_close(db)
    }
}
