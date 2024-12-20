import Foundation
import Combine
import GRDB

enum DatabaseError: Error, LocalizedError {
    case alreadyConnected
    case connectionFailed(String)
    case migrationFailed(String)
    case connectionNotEstablished
    case csvImportFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .alreadyConnected:
            return "Database is already connected."
        case .connectionFailed(let details):
            return "Failed to connect to the database. Details: \(details)"
        case .migrationFailed(let details):
            return "Migration failed. Details: \(details)"
        case .connectionNotEstablished:
            return "Database connection is not established."
        case .csvImportFailed(let details):
            return "CSV import failed. Details: \(details)"
        }
    }
}

final class DatabaseManager: ObservableObject {
    @Published private(set) var isConnected: Bool = false
    static let shared = DatabaseManager()
    
    private var dbQueue: DatabaseQueue?
    private var databaseURL: URL?
    private init() {}
    
    var databaseQueue: DatabaseQueue? {
        return dbQueue
    }
    
    func connect(dbName: String) throws {
        guard dbQueue == nil else {
            Logger.debug("[Database]: Already connected")
            throw DatabaseError.alreadyConnected
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
                Logger.debug("[DatabaseManager]: Migration started at path: \(databaseURL!.path)")
                do {
                    try migrator.migrate(dbQueue)
                    isConnected = true
                    Logger.debug("[DatabaseManager]: Connection established")
                } catch {
                    throw DatabaseError.migrationFailed(error.localizedDescription)
                }
            }
        } catch {
            throw DatabaseError.connectionFailed(error.localizedDescription)
        }
    }
    
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[DatabaseManager]: Disconnected")
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DictionaryItemModel.createTable(in: db)
            Logger.debug("[DatabaseManager]: 'Dictionary' table created successfully")
            
            let internalDictionary = DictionaryItemModel(
                key: "internal",
                displayName: "Main",
                tableName: "Internal",
                description: "LingoCards default dictionary",
                category: "LingoCards",
                subcategory: "internal",
                author: "LingoCards"
            )
            if try DictionaryItemModel
                .filter(Column("displayName") == internalDictionary.displayName)
                .fetchOne(db) == nil {
                try internalDictionary.insert(db)
                Logger.debug("[DatabaseManager]: 'Internal' dictionary entry added successfully")
            } else {
                Logger.debug("[DatabaseManager]: 'Internal' dictionary entry already exists")
            }
        }
        migrator.registerMigration("createWords") { db in
            try WordItemModel.createTable(in: db)
            Logger.debug("[DatabaseManager]: 'Words' table created successfully")
        }
        return migrator
    }
}
