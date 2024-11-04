import Foundation
import Combine

class BaseApiViewModel: BaseViewModel, ObservableObject {
    func performApiOperation<T>(
        _ operation: @escaping () async throws -> T,
        successHandler: @escaping (T) -> Void,
        
        source: ErrorSourceModel,
        frame: AppFrameModel,
        message: String,
        localized: String = LanguageManager.shared.localizedString(for: "ErrApiDefault").capitalizedFirstLetter,
        
        additionalInfo: [String: String] = [:],
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
                        type: .api,
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
