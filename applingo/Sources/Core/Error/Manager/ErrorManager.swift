import Foundation
import SwiftUI
import Combine

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    
    @Published var currentError: AppError? {
        didSet {
            if let error = currentError {
                Logger.debug("Showing error: \(error.title)")
            }
        }
    }
    
    private let processors: [ErrorProcessor]
    private let handlers: [ErrorHandler]
    private let reporters: [ErrorReporter]
    
    private let queue = DispatchQueue(label: "com.applingo.error-manager", qos: .userInitiated)
    
    init(
        processors: [ErrorProcessor] = [
            NetworkErrorProcessor(),
        ],
        handlers: [ErrorHandler] = [
            AlertErrorHandler()
        ],
        reporters: [ErrorReporter] = [
            LogErrorReporter(),
        ]
    ) {
        self.processors = processors
        self.handlers = handlers
        self.reporters = reporters
        Logger.debug("[ErrorManager]: Initialize manager")
    }
    
    func process(_ error: Error, screen: ScreenType) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            let appError = self.processors
                .compactMap { $0.process(error) }
                .first ?? self.createDefaultError(from: error, screen: screen)
            
            self.handlers.forEach { $0.handle(appError) }
            self.reporters.forEach { $0.report(appError) }
            
            if appError.type.isUserFacing {
                DispatchQueue.main.async {
                    self.currentError = appError
                }
            }
        }
    }
    
    private func createDefaultError(from error: Error, screen: ScreenType) -> AppError {
        AppError(
            type: .unknown,
            originalError: error,
            context: AppErrorContext(
                source: .unknown,
                screen: screen,
                metadata: [:],
                severity: .error
            ),
            title: LocaleManager.shared.localizedString(for: "error.unknown.title"),
            message: error.localizedDescription
        )
    }
}
