import Foundation
import Combine

class ProcessDatabase: BaseBackend, ObservableObject {
    func performDatabaseOperation<T>(
        _ operation: @escaping () throws -> T,
        success: @escaping (T) -> Void,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let result = try operation()
                
                DispatchQueue.main.async {
                    success(result)
                    completion?(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    self.handleError(error, screen: screen, metadata: metadata)
                    completion?(.failure(error))
                }
            }
        }
    }
}
