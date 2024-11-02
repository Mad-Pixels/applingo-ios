import Foundation

class BaseViewModel {
    func handleError(
        error: Error,
        source: ErrorSourceModel,
        message: String,
        frame: AppFrameModel,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        let appError = AppErrorModel(
            errorType: .database,
            errorMessage: message,
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, frame: frame, source: source)
        completion?(.failure(appError))
    }
}
