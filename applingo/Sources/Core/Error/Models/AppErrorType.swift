import Foundation

enum AppErrorType {
    case validation(field: String)
    case network(statusCode: Int)
    case database(operation: String)
    case business(code: String)
    case ui(component: String)
    case parser
    case unknown
    
    var isUserFacing: Bool {
        switch self {
        case .validation, .ui: return true
        case .network(let statusCode):
            return (400...499).contains(statusCode)
        case .database: return true
        case .parser: return true
        case .business: return true
        case .unknown: return true
        }
    }
    
    var localizedTitle: String {
        switch self {
        case .validation:
            return LocaleManager.shared.localizedString(for: "error.validation.title")
        case .network:
            return LocaleManager.shared.localizedString(for: "error.network.title")
        case .database:
            return LocaleManager.shared.localizedString(for: "error.database.title")
        case .parser:
            return LocaleManager.shared.localizedString(for: "error.parser.title")
        case .business:
            return LocaleManager.shared.localizedString(for: "error.business.title")
        case .ui:
            return LocaleManager.shared.localizedString(for: "error.ui.title")
        case .unknown:
            return LocaleManager.shared.localizedString(for: "error.unknown.title")
        }
    }
}
