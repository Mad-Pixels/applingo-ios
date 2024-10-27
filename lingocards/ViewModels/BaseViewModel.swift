import Foundation

class BaseViewModel {
    func handleError(
        error: Error,
        source: ErrorSource,
        message: String,
        tab: AppTab,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        let appError = AppError(
            errorType: .database,
            errorMessage: message,
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, tab: tab, source: source)
        completion?(.failure(appError))
    }
}
