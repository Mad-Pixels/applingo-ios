import Foundation
import GRDB
import Combine

class BaseDatabaseViewModel: BaseViewModel, ObservableObject {
    func performDatabaseOperation<T>(
        _ operation: @escaping () throws -> T,
        successHandler: @escaping (T) -> Void,
        
        source: ErrorSourceModel,
        frame: AppFrameModel,
        message: String,
        localized: String = LanguageManager.shared.localizedString(for: "ErrDatabaseDefault").capitalizedFirstLetter,
        
        additionalInfo: [String: String] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let result = try operation()
                DispatchQueue.main.async {
                    successHandler(result)
                    completion?(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(
                        type: .database,
                        source: source,
                        message: message,
                        localized: localized,
                        original: error,
                        additional: additionalInfo,
                        frame: frame,
                        completion: completion
                    )
                }
            }
        }
    }
}
