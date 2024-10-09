import Foundation
import Combine

enum GlobalError: Error, LocalizedError, Identifiable, Equatable {
    var id: UUID { UUID() }

    case custom(appError: AppError, tab: AppTab, source: ErrorSource)
    
    var errorDescription: String? {
        switch self {
        case .custom(let appError, _, _):
            return appError.errorDescription
        }
    }

    var tab: AppTab {
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
    
    @Published var currentError: GlobalError?
    @Published var isErrorVisible: Bool = false

    private init() {}

    func setError(appError: AppError, tab: AppTab, source: ErrorSource) {
        let error = GlobalError.custom(appError: appError, tab: tab, source: source)
        logError(appError)
        DispatchQueue.main.async {
            self.objectWillChange.send()
            self.currentError = error
            self.isErrorVisible = true
            Logger.debug("[ErrorManager]: Error set: \(appError.errorMessage), isVisible: \(self.isErrorVisible)")
        }
    }

    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.isErrorVisible = false
            Logger.debug("[ErrorManager]: Error cleared, isVisible: \(self.isErrorVisible)")
        }
    }

    func clearError(for source: ErrorSource) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.source == source {
                self.currentError = nil
                self.isErrorVisible = false
                Logger.debug("[ErrorManager]: Error for source \(source) cleared")
            }
        }
    }

    func clearErrors(for tab: AppTab) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.tab == tab {
                self.currentError = nil
                self.isErrorVisible = false
            }
        }
    }
    
    func isVisible(for tab: AppTab, source: ErrorSource) -> Bool {
        return isErrorVisible && currentError?.tab == tab && currentError?.source == source
    }
    
    private func logError(_ appError: AppError) {
        LogHandler.shared.sendError(appError.errorMessage, type: appError.errorType, additionalInfo: appError.additionalInfo)
    }
}
