enum AppErrorType {
    case database(operation: DatabaseOperation)
    case network(statusCode: Int)
    case unknown
    
    var isUserFacing: Bool {
        switch self {
        case .network, .database: return false
        case .unknown: return false
        }
    }
    
//    var isUserFacing: Bool {
//            switch self {
//            case .validation(let field):
//                // Показываем пользователю ошибки валидации
//                return true
//            case .network(let statusCode):
//                // Например, показываем только 4xx ошибки
//                return (400...499).contains(statusCode)
//            case .database:
//                // Ошибки БД не показываем пользователю
//                return false
//            case .business(let code):
//                // Показываем только определенные бизнес-ошибки
//                return ["USER_INPUT", "VALIDATION"].contains(code)
//            case .ui:
//                return true
//            case .unknown:
//                return false
//            }
//        }
}
