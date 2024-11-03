import Foundation
import Combine

class BaseApiViewModel: BaseViewModel, ObservableObject {
    func performApiOperation<T>(
        _ operation: @escaping () async throws -> T,
        successHandler: @escaping (T) -> Void,
        errorType: ErrorTypeModel,
        errorSource: ErrorSourceModel,
        errorMessage: String,
        frame: AppFrameModel,
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        Task {
            do {
                let result = try await operation()
                await MainActor.run {
                    successHandler(result)
                    completion?(.success(()))
                }
            } catch {
                await MainActor.run {
                    self.handleError(
                        error: error,
                        errorType: errorType,
                        source: errorSource,
                        message: errorMessage,
                        frame: frame,
                        completion: completion
                    )
                }
            }
        }
    }
}
