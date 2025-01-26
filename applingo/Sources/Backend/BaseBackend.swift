import Foundation

class BaseBackend {
    func handleError(_ error: Error, screen: ScreenType, metadata: [String: Any] = [:]) {
        ErrorManager.shared.process(error, screen: screen, metadata: metadata)
    }
}
