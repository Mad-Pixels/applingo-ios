import GRDB

/// A structure representing an SQL condition with its associated query and arguments.
/// Used for dynamically building SQL queries with placeholder values.
struct SQLCondition {
    /// The SQL query string with placeholders for arguments.
    let sql: String
    
    /// The arguments to be substituted into the SQL query.
    let arguments: [DatabaseValueConvertible]
    
    /// Initializes an `SQLCondition` with the provided SQL string and arguments.
    /// - Parameters:
    ///   - sql: The SQL query string.
    ///   - arguments: The arguments for the query placeholders.
    init(sql: String, arguments: [DatabaseValueConvertible]) {
        self.sql = sql
        self.arguments = arguments
    }
}
