import Foundation

class BaseViewModel {
    func handleError(
        type: ErrorTypeModel,
        source: ErrorSourceModel,
        message: String,
        localized: String,
        original: Error?,
        additional: [String: String],
        frame: AppFrameModel,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        let appError = AppErrorModel(
            type: type,
            message: message,
            localized: localized,
            original: original,
            additional: additional
        )
        ErrorManager.shared.setError(appError: appError, frame: frame, source: source)
        completion?(.failure(appError))
    }
}
