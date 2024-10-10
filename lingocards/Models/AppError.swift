import Foundation

enum ErrorType: String, Codable {
    case database
    case network
    case unknown
    case api
    case ui
}

enum ErrorSource: String {
    case getWords
    case fetchData
    case saveWord
    case unknown
    case deleteWord
    case updateWord
    case getDictionaries
    case deleteDictionary
    case updateDictionary
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
