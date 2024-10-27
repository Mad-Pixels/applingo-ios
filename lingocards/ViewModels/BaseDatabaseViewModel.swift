import Foundation
import GRDB
import Combine

class BaseDatabaseViewModel: BaseViewModel, ObservableObject {    
    func performDatabaseOperation<T>(
        _ operation: @escaping () throws -> T,
        successHandler: @escaping (T) -> Void,
        errorSource: ErrorSource,
        errorMessage: String,
        tab: AppTab,
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
                        error: error,
                        source: errorSource,
                        message: errorMessage,
                        tab: tab,
                        completion: completion
                    )
                }
            }
        }
    }
}
