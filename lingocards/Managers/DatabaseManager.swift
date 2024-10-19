import Foundation
import Combine
import UIKit
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
    
    /// global database initialization which execute on MainView
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
    
    /// exec transaction fot adding data from CSV
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
                    description: "Imported from local file: \(url.deletingPathExtension().lastPathComponent)",
                    category: "Local",
                    subcategory: "personal",
                    author: UIDevice.current.name
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
    
    /// migration: create main Dictionary table.
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        migrator.registerMigration("createDictionary") { db in
            try DictionaryItem.createTable(in: db)
            Logger.debug("[Database]: Dictionary table created successfully")
        }
        return migrator
    }
}
