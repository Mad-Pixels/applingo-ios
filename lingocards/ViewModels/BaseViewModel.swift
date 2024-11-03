import Foundation

class BaseViewModel {
    func handleError(
        error: Error,
        errorType: ErrorTypeModel,
        source: ErrorSourceModel,
        message: String,
        frame: AppFrameModel,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        let appError = AppErrorModel(
            errorType: errorType,
            errorMessage: message,
            localizedMessage: "asd",
            additionalInfo: ["error": "\(error)"]
        )
        ErrorManager.shared.setError(appError: appError, frame: frame, source: source)
        completion?(.failure(appError))
    }
}
