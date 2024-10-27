import Foundation
import Combine
import GRDB

class DatabaseManager: ObservableObject {
    @Published private(set) var isConnected: Bool = false
    static let shared = DatabaseManager()
    
    private let dbName = "LingocardDB.sqlite"
    private var dbQueue: DatabaseQueue?
    private var databaseURL: URL?
    private init() {}
    
    var databaseQueue: DatabaseQueue? {
        return dbQueue
    }
    
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
                Logger.debug("[DatabaseManager]: Migration started at path: \(databaseURL!.path)")
                try migrator.migrate(dbQueue)
                isConnected = true
                Logger.debug("[DatabaseManager]: Connection established")
            }
        } catch {
            let appError = AppError(
                errorType: .database,
                errorMessage: "Connection failed",
                additionalInfo: ["path": "\(databaseURL!.path)", "error": "\(error.localizedDescription)"]
            )
            ErrorManager.shared.setError(appError: appError, tab: .main, source: .initialization)
            throw appError
        }
    }
    
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[DatabaseManager]: Disconnected")
    }
    
    func importCSVFile(at url: URL) throws {
        guard isConnected, let dbQueue = databaseQueue else {
            let appError = AppError(
                errorType: .database,
                errorMessage: "Connection not established",
                additionalInfo: ["path": "\(databaseURL!.path)"]
            )
            ErrorManager.shared.setError(appError: appError, tab: .dictionaries, source: .importCSVFile)
            throw appError
        }

        let tableName = url.deletingPathExtension().lastPathComponent
        let wordItems = try CSVImporter.parseCSV(at: url, tableName: tableName)
        
        let dictionaryItem = DictionaryItem(
            displayName: tableName,
            tableName: tableName,
            description: "Imported from local file: '\(tableName).csv'",
            category: "Local",
            subcategory: "personal",
            author: "local user"
        )

        try dbQueue.write { db in
            try dictionaryItem.insert(db)
            
            for var wordItem in wordItems {
                wordItem.tableName = tableName
                try wordItem.insert(db)
            }
            Logger.debug("[Database]: Inserted \(wordItems.count) word items for table \(tableName)")
        }
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DictionaryItem.createTable(in: db)
            Logger.debug("[DatabaseManager]: 'Dictionary' table created successfully")
            
            let internalDictionary = DictionaryItem(
                displayName: "Main",
                tableName: "Internal",
                description: "LingoCards default dictionary",
                category: "LingoCards",
                subcategory: "internal",
                author: "LingoCards"
            )
            if try DictionaryItem
                .filter(Column("displayName") == internalDictionary.displayName)
                .fetchOne(db) == nil {
                try internalDictionary.insert(db)
                Logger.debug("[DatabaseManager]: 'Internal' dictionary entry added successfully")
            } else {
                Logger.debug("[DatabaseManager]: 'Internal' dictionary entry already exists")
            }
        }
        
        migrator.registerMigration("createWords") { db in
            try WordItem.createTable(in: db)
            Logger.debug("[DatabaseManager]: 'Words' table created successfully")
        }
        
        return migrator
    }
}
