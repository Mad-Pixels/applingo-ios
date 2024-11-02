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
    case dictionariesRemoteGet
    case categoriesGet
    case initialization
    case importCSVFile
}

struct AppErrorModel: Error, LocalizedError, Equatable, Identifiable {
    let id: UUID = UUID()
    let errorType: ErrorTypeModel
    let errorMessage: String
    let additionalInfo: [String: String]?

    var errorDescription: String? {
        errorMessage
    }
    
    static func ==(lhs: AppErrorModel, rhs: AppErrorModel) -> Bool {
        return lhs.errorMessage == rhs.errorMessage && lhs.errorType == rhs.errorType && lhs.additionalInfo == rhs.additionalInfo
    }
}
