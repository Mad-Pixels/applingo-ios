import Foundation
import Combine

/// Аналог 'BaseBackend' + ObservableObject, если хотите наследовать общие методы
class ProcessApi: BaseBackend, ObservableObject {
    
    /// Универсальный метод для выполнения асинхронных API-операций
    func performApiOperation<T>(
        _ operation: @escaping () async throws -> T,
        success: @escaping (T) -> Void,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        completion: ((Result<Void, Error>) -> Void)? = nil
    ) {
        Task {
            do {
                let result = try await operation()
                await MainActor.run {
                    success(result)
                    completion?(.success(()))
                }
            } catch {
                Logger.debug("Error: \(error)")
                await MainActor.run {
                    // Обрабатываем ошибку через новый ErrorManager
                    // (внутри handleError(...) происходит вызов ErrorManager.shared.process(...))
                    self.handleError(error, screen: screen, metadata: metadata)
                    completion?(.failure(error))
                }
            }
        }
    }
}

