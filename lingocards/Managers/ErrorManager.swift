import Foundation
import Combine

enum GlobalError: Error, LocalizedError, Identifiable, Equatable {
    var id: UUID { UUID() }

    case custom(appError: AppErrorModel, frame: AppFrameModel, source: ErrorSourceModel)
    
    var errorDescription: String? {
        switch self {
        case .custom(let appError, _, _):
            return appError.errorDescription
        }
    }

    var frame: AppFrameModel {
        switch self {
        case .custom(_, let context, _):
            return context
        }
    }
    
    var source: ErrorSourceModel {
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

    func setError(appError: AppErrorModel, frame: AppFrameModel, source: ErrorSourceModel) {
        let error = GlobalError.custom(appError: appError, frame: frame, source: source)
        if appError.errorType != .ui {
            logError(appError)
        }
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

    func clearError(for source: ErrorSourceModel) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.source == source {
                self.currentError = nil
                self.isErrorVisible = false
                Logger.debug("[ErrorManager]: Error for source \(source) cleared")
            }
        }
    }

    func clearErrors(for frame: AppFrameModel) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.frame == frame {
                self.currentError = nil
                self.isErrorVisible = false
            }
        }
    }
    
    func isVisible(for frame: AppFrameModel, source: ErrorSourceModel) -> Bool {
        return isErrorVisible && currentError?.frame == frame && currentError?.source == source
    }
    
    private func logError(_ appError: AppErrorModel) {
        LogHandler.shared.sendError(appError.errorMessage, type: appError.errorType, additionalInfo: appError.additionalInfo)
    }
}
