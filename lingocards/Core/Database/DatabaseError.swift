// Перечисление возможных ошибок при работе с базой данных
enum DatabaseError: Error {
    case fileCreationError(String)
    case connectionError(String)
    case queryError(String)
}
