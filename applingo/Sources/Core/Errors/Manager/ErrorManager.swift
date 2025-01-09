import Foundation

final class ErrorManager: ObservableObject {
    static let shared = ErrorManager()
    
    // Делаем currentError с публичным сеттером
    @Published var currentError: AppError?
    
    private let processors: [ErrorProcessor]
    private let handlers: [ErrorHandler]
    private let reporters: [ErrorReporter]
    
    private let queue = DispatchQueue(label: "com.app.error-manager", qos: .userInitiated)
    
    init(
        processors: [ErrorProcessor] = [],
        handlers: [ErrorHandler] = [],
        reporters: [ErrorReporter] = []
    ) {
        self.processors = processors
        self.handlers = handlers
        self.reporters = reporters
    }
    
    func process(_ error: Error, screen: AppScreen) {
        queue.async { [weak self] in
            guard let self = self else { return }
            
            // 1. Преобразование в AppError
            let appError = self.processors
                .compactMap { $0.process(error) }
                .first ?? self.createDefaultError(from: error, screen: screen)
            
            // 2. Обработка
            self.handlers.forEach { $0.handle(appError) }
            
            // 3. Репортинг
            self.reporters.forEach { $0.report(appError) }
            
            // 4. UI обновление если нужно
            if appError.type.isUserFacing {
                DispatchQueue.main.async {
                    self.currentError = appError
                }
            }
        }
    }
    
    private func createDefaultError(from error: Error, screen: AppScreen) -> AppError {
        AppError(
            type: .unknown,
            originalError: error,
            context: AppErrorContext(
                source: .unknown,
                screen: screen,
                metadata: [:],
                severity: .error
            ),
            timestamp: Date(),
            title: "Error",
            message: error.localizedDescription,
            actionTitle: "OK",
            action: nil
        )
    }
}

