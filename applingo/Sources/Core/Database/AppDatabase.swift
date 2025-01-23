import Foundation
import Combine
import GRDB

final class AppDatabase: ObservableObject {
    @Published private(set) var isConnected: Bool = false
    static let shared = AppDatabase()
    
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
                uuid: "internal",
                name: "Main",
                author: "LingoCards",
                category: "LingoCards",
                subcategory: "internal",
                description: "LingoCards default dictionary"
            )
            if try DictionaryItemModel
                .filter(Column("name") == internalDictionary.name)
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
