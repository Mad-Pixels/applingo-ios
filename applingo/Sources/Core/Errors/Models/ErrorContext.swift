struct AppErrorContext {
    let source: ErrorSource
    let screen: AppScreen
    let metadata: [String: Any]
    let severity: ErrorSeverity
    
    enum ErrorSeverity {
        case debug
        case info
        case warning
        case error
        case critical
    }
}
