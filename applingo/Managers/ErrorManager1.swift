import Foundation
import Combine
//
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
    
    var localizedMessage: String {
        switch self {
        case .custom(let appError, _, _):
            return appError.localized
        }
    }
}

final class ErrorManager1: ObservableObject {
    static let shared = ErrorManager1()
    
    @Published var currentError: GlobalError?
    private(set) var isErrorVisible: Bool = false

    private init() {}

    func setError(appError: AppErrorModel, frame: AppFrameModel, source: ErrorSourceModel) {
        let error = GlobalError.custom(appError: appError, frame: frame, source: source)
        if appError.type != .ui {
            logError(appError)
        }
        DispatchQueue.main.async {
            self.currentError = error
            self.isErrorVisible = true
            Logger.debug("[ErrorManager]: Error set: \(appError.message), isVisible: \(self.isErrorVisible)")
            NotificationCenter.default.post(name: .errorVisibilityChanged, object: nil)
        }
    }

    func clearError() {
        DispatchQueue.main.async {
            self.currentError = nil
            self.isErrorVisible = false
            Logger.debug("[ErrorManager]: Error cleared, isVisible: \(self.isErrorVisible)")
            NotificationCenter.default.post(name: .errorVisibilityChanged, object: nil)
        }
    }

    func clearError(for source: ErrorSourceModel) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.source == source {
                self.currentError = nil
                self.isErrorVisible = false
                Logger.debug("[ErrorManager]: Error for source \(source) cleared")
                NotificationCenter.default.post(name: .errorVisibilityChanged, object: nil)
            }
        }
    }

    func clearErrors(for frame: AppFrameModel) {
        DispatchQueue.main.async {
            if let currentError = self.currentError, currentError.frame == frame {
                self.currentError = nil
                self.isErrorVisible = false
                Logger.debug("[ErrorManager]: Errors for frame \(frame) cleared")
                NotificationCenter.default.post(name: .errorVisibilityChanged, object: nil)
            }
        }
    }

    private func logError(_ appError: AppErrorModel) {
        LogHandler.shared.sendError(
            appError.message,
            type: appError.type,
            original: appError.original,
            additionalInfo: appError.additional
        )
    }
}
