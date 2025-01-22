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
            Logger.debug("[AppDatabase]: Already connected")
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
                Logger.debug("[AppDatabase]: Migration started at path: \(databaseURL!.path)")
                do {
                    try migrator.migrate(dbQueue)
                    isConnected = true
                    Logger.debug("[AppDatabase]: Connection established")
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
        Logger.debug("[AppDatabase]: Disconnected")
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DatabaseDictionary.createTable(in: db)
            Logger.debug("[AppDatabase]: 'Dictionary' table created successfully")
            
            let internalDictionary = DatabaseDictionary(
                name: "Main",
                author: "MadPixels",
                category: "AppLingo",
                subcategory: "internal",
                description: "AppLingo default dictionary"
            )
            
            if try DatabaseDictionary
                .filter(Column("name") == internalDictionary.name)
                .fetchOne(db) == nil {
                try internalDictionary.insert(db)
                Logger.debug("[AppDatabase]: 'Main' dictionary entry added successfully")
            } else {
                Logger.debug("[AppDatabase]: 'Main' dictionary entry already exists")
            }
        }
        
        migrator.registerMigration("createWords") { db in
            try DatabaseWord.createTable(in: db)
            Logger.debug("[AppDatabase]: 'Words' table created successfully")
        }
        
        return migrator
    }
}
