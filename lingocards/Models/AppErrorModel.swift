import Foundation

enum ErrorType: String, Codable {
    case database
    case network
    case unknown
    case api
    case ui
}

enum ErrorSource: String {
    case wordsGet
    case wordAdd
    case wordSave
    case wordDelete
    case wordUpdate
    case dictionariesGet
    case dictionaryDelete
    case dictionaryUpdate
    case dictionariesRemoteGet
    case categoriesGet
    case initialization
    case importCSVFile
}

struct AppError: Error, LocalizedError, Equatable, Identifiable {
    let id: UUID = UUID()
    let errorType: ErrorType
    let errorMessage: String
    let additionalInfo: [String: String]?

    var errorDescription: String? {
        errorMessage
    }
    
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        return lhs.errorMessage == rhs.errorMessage && lhs.errorType == rhs.errorType && lhs.additionalInfo == rhs.additionalInfo
    }
}
