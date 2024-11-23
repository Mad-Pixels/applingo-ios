import GRDB

struct SQLCondition {
    let sql: String
    let arguments: [DatabaseValueConvertible]
}
