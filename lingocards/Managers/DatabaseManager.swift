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
    
    func importCSVFile(at url: URL) throws {
        guard isConnected, let dbQueue = dbQueue else {
            let appError = AppError(
                errorType: .database,
                errorMessage: "[Database]: Check database connection return false",
                additionalInfo: ["path": "\(databaseURL!.path)"]
            )
            ErrorManager.shared.setError(appError: appError, tab: .dictionaries, source: .importCSVFile)
            throw appError
        }

        let tableName = "words_\(UUID().uuidString.replacingOccurrences(of: "-", with: "_"))"
        let wordItems = try CSVImporter.parseCSV(at: url, tableName: tableName)

        try dbQueue.write { db in
            do {
                try WordItem.createTable(in: db, tableName: tableName)
                Logger.debug("[Database]: Table \(tableName) created")

                for var wordItem in wordItems {
                    wordItem.tableName = tableName
                    try wordItem.insert(db)
                }
                Logger.debug("[Database]: \(wordItems.count) words imported")

                var dictionaryItem = DictionaryItem(
                    displayName: url.deletingPathExtension().lastPathComponent,
                    tableName: tableName,
                    description: "Imported from local file: '\(url.deletingPathExtension().lastPathComponent).csv'",
                    category: "Local",
                    subcategory: "personal",
                    author: "local user"
                )
                Logger.debug("[Database]: Dictionary item created")
                
                try dictionaryItem.insert(db)
                Logger.debug("[Database]: CSV file imported successfully")
            } catch {
                let appError = AppError(
                    errorType: .database,
                    errorMessage: "[Database]: Importing CSV file failed",
                    additionalInfo: ["error": "\(error)"]
                )
                ErrorManager.shared.setError(appError: appError, tab: .dictionaries, source: .importCSVFile)
                throw appError
            }
        }
    }
    
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[Database]: Disconnected.")
    }
    
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DictionaryItem.createTable(in: db)
            Logger.debug("[Migrations]: 'Dictionary' table created successfully")
        }
        
        migrator.registerMigration("createInternal") { db in
            try WordItem.createTable(in: db, tableName: "Internal")
            Logger.debug("[Migrations]: 'Internal' table created")
                    
            let dictionaryItem = DictionaryItem(
                displayName: "main",
                tableName: "Internal",
                description: "Internal app dictionary",
                category: "LingoCards",
                subcategory: "Main",
                author: "LingoCards",
                isPrivate: false,
                isActive: true
            )
            try dictionaryItem.insert(db)
            Logger.debug("[Migrations]: 'Internal' dictionary entry added")
        }
        
        return migrator
    }
}
