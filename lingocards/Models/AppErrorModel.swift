import Foundation

enum ErrorTypeModel: String, Codable {
    case database
    case network
    case unknown
    case api
    case ui
}

enum ErrorSourceModel: String {
    case wordsGet
    case wordAdd
    case wordSave
    case wordDelete
    case wordUpdate
    case wordsClear
    case dictionariesGet
    case dictionaryDelete
    case dictionaryUpdate
    case dictionarySave
    case dictionariesClear
    case dictionaryImport
    case dictionaryDisplayName
    case dictionariesRemoteGet
    case categoriesGet
    case initialization
}

struct AppErrorModel: Error, LocalizedError, Equatable, Identifiable {
    let id: UUID = UUID()
    let type: ErrorTypeModel
    let message: String
    let localized: String
    let original: Error?
    let additional: [String: String]?
    
    var errorDescription: String? {
        message
    }

    static func ==(lhs: AppErrorModel, rhs: AppErrorModel) -> Bool {
        return lhs.message == rhs.message &&
               lhs.type == rhs.type &&
               lhs.additional == rhs.additional &&
               ((lhs.original?.localizedDescription == rhs.original?.localizedDescription) ||
                (lhs.original == nil && rhs.original == nil))
    }
}
