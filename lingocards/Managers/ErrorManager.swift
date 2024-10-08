import Foundation
import Combine

enum GlobalError: Error, LocalizedError, Identifiable, Equatable {
    var id: UUID { UUID() }

    case custom(message: String, context: ErrorContext, source: ErrorSource)
    
    var errorDescription: String? {
        switch self {
        case .custom(let message, _, _):
            return message
        }
    }

    var context: ErrorContext {
        switch self {
        case .custom(_, let context, _):
            return context
        }
    }
    
    var source: ErrorSource {
        switch self {
        case .custom(_, _, let source):
            return source
        }
    }
}

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    private var dismissTimer: AnyCancellable?

    @Published var currentError: GlobalError?
    @Published var isErrorVisible: Bool = false
    
    private init() {}

    func setError(message: String, context: ErrorContext, source: ErrorSource, dismissAfter seconds: TimeInterval = 7.5) {
        let error = GlobalError.custom(message: message, context: context, source: source)
        setError(error, dismissAfter: seconds)
    }

    func setError(_ error: GlobalError, dismissAfter seconds: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            self.currentError = error
            self.isErrorVisible = true
            self.startDismissTimer(after: seconds)
        }
    }

    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.isErrorVisible = false
            self.dismissTimer?.cancel()
        }
    }

    func clearError(for source: ErrorSource) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.source == source {
                self.currentError = nil
                self.isErrorVisible = false
                self.dismissTimer?.cancel()
            }
        }
    }

    private func startDismissTimer(after seconds: TimeInterval) {
        dismissTimer?.cancel()

        dismissTimer = Just(())
            .delay(for: .seconds(seconds), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.clearError()
            }
    }
}
