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
            Logger.debug(
                "[Database]: Already connected"
            )
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
                Logger.debug(
                    "[Database]: Migration started at path: \(databaseURL!.path)"
                )
                do {
                    try migrator.migrate(dbQueue)
                    isConnected = true
                    Logger.debug(
                        "[Database]: Connection established"
                    )
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
        Logger.debug("[Database]: Disconnected")
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DatabaseModelDictionary.createTable(in: db)
            Logger.debug(
                "[Database]: 'Dictionary' table created successfully"
            )
            
            let internalDictionary = DatabaseModelDictionary.newInternal()
            if try DatabaseModelDictionary
                .filter(Column("name") == internalDictionary.name)
                .fetchOne(db) == nil {
                try internalDictionary.insert(db)
                Logger.debug(
                    "[Database]: 'Internal' dictionary entry added successfully"
                )
            } else {
                Logger.debug(
                    "[Database]: 'Internal' dictionary entry already exists"
                )
            }
        }
        migrator.registerMigration("createWords") { db in
            try DatabaseModelWord.createTable(in: db)
            Logger.debug(
                "[Database]: 'Words' table created successfully"
            )
        }
        return migrator
    }
}
