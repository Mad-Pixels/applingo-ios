enum DatabaseError: Error {
    case fileCreationError(String)
    case connectionError(String)
    case queryError(String)
    
    
//    var errorDescription: String? {
//        switch self {
//        case .fileCreationError(let message):
//            return NSLocalizedString("File Creation Error: \(message)", comment: "")
//        case .connectionError(let message):
//            return NSLocalizedString("Connection Error: \(message)", comment: "")
//        case .queryError(let message):
//            return NSLocalizedString("Query Error: \(message)", comment: "")
//        }
//    }
}
