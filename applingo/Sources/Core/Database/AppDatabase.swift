import Foundation
import Combine
import GRDB

/// A singleton class for managing the app's database connection, migrations, and operations.
final class AppDatabase: ObservableObject {
    // MARK: - Properties

    /// Indicates whether the database is currently connected.
    @Published private(set) var isConnected: Bool = false

    /// Shared instance of `AppDatabase`.
    static let shared = AppDatabase()

    /// The active database queue for executing SQL queries.
    private var dbQueue: DatabaseQueue?

    /// The URL of the database file.
    private var databaseURL: URL?

    /// Accessor for the current database queue.
    var databaseQueue: DatabaseQueue? {
        return dbQueue
    }

    // MARK: - Initialization

    /// Private initializer to enforce singleton pattern.
    private init() {}

    // MARK: - Public Methods

    /// Connects to the database, creating and migrating tables if necessary.
    /// - Parameter dbName: The name of the database file.
    /// - Throws: `DatabaseError` if the connection or migration fails.
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
                Logger.debug("[Database]: Migration started at path: \(databaseURL!.path)")

                do {
                    try migrator.migrate(dbQueue)
                    isConnected = true
                    Logger.debug("[Database]: Connection established")
                } catch {
                    throw DatabaseError.migrationFailed(error.localizedDescription)
                }
            }
        } catch {
            throw DatabaseError.connectionFailed(error.localizedDescription)
        }
    }

    /// Disconnects the database by deinitializing the queue and resetting the connection state.
    func disconnect() {
        dbQueue = nil
        isConnected = false
        Logger.debug("[Database]: Disconnected")
    }

    // MARK: - Private Properties

    /// Configures and returns the database migrator for handling migrations.
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        // Migration for the 'dictionary' table.
        migrator.registerMigration("createDictionary") { db in
            try DatabaseModelDictionary.createTable(in: db)
            Logger.debug("[Database]: 'Dictionary' table created successfully")

            let internalDictionary = DatabaseModelDictionary.newInternal()
            if try DatabaseModelDictionary
                .filter(Column("name") == internalDictionary.name)
                .fetchOne(db) == nil {
                try internalDictionary.insert(db)
                Logger.debug("[Database]: 'Internal' dictionary entry added successfully")
            } else {
                Logger.debug("[Database]: 'Internal' dictionary entry already exists")
            }
        }

        // Migration for the 'words' table.
        migrator.registerMigration("createWords") { db in
            try DatabaseModelWord.createTable(in: db)
            Logger.debug("[Database]: 'Words' table created successfully")
        }

        return migrator
    }
}
