import Foundation

struct AppErrorContext {
    let source: ErrorSource
    let screen: ScreenType
    let metadata: [String: Any]
    let severity: ErrorSeverity
    
    init(
        source: ErrorSource,
        screen: ScreenType,
        metadata: [String: Any] = [:],
        severity: ErrorSeverity = .error
    ) {
        self.source = source
        self.screen = screen
        self.metadata = metadata
        self.severity = severity
    }
}

extension AppErrorContext {
    enum ErrorSource: String {
        case network
        case database
        case parser
        case unknown
    }
    
    enum ErrorSeverity: String {
        case debug
        case info
        case warning
        case error
        case critical
    }
}
