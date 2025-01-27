import CocoaLumberjackSwift
import Foundation

// MARK: - Logger

/// A logger wrapper built on top of CocoaLumberjack,
/// providing convenience methods and an option to send errors to the server via LogHandler.
struct Logger {
    
    /// Log levels mapped to CocoaLumberjack `DDLogLevel`.
    enum LogLevel {
        case info, debug, warning, error, verbose
        
        var lumberjackLevel: DDLogLevel {
            switch self {
            case .info:     return .info
            case .debug:    return .debug
            case .warning:  return .warning
            case .error:    return .error
            case .verbose:  return .verbose
            }
        }
    }

    // MARK: - Initialization
    
    /// Initializes CocoaLumberjack. Call this once in app lifecycle (e.g., in `AppDelegate`).
    static func initializeLogger() {
        DDLog.removeAllLoggers()
        let consoleLogger = DDOSLogger.sharedInstance
        DDLog.add(consoleLogger, with: .debug)
    }
    
    // MARK: - Logging Methods
    
    /// Generic logging method.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The `LogLevel` for the message.
    ///   - type: An optional `ErrorTypeModel` if this log represents an error that might need remote sending.
    ///   - original: An optional Swift `Error` object.
    ///   - metadata: Additional metadata for the log.
    static func log(
        _ message: @autoclosure () -> String,
        level: LogLevel = .info,
        type: ErrorTypeModel? = nil,
        original: Error? = nil,
        metadata: [String: String]? = nil
    ) {
        let resolvedMessage = message()
        
        let ddMessage = DDLogMessage(
            message: resolvedMessage,
            level: level.lumberjackLevel,
            flag: logFlag(for: level),
            context: 0,
            file: "",
            function: "",
            line: 0,
            tag: nil,
            options: [.copyFile, .copyFunction],
            timestamp: nil
        )
        
        // Write to CocoaLumberjack
        DDLog.sharedInstance.log(asynchronous: true, message: ddMessage)

        // Additionally send an error log to the server if conditions are met
        if level == .error, let errorType = type, LogHandler.shared.sendLogs {
            LogHandler.shared.sendError(
                resolvedMessage,
                type: errorType,
                original: original,
                additionalInfo: metadata
            )
        }
    }

    /// Shortcut for logging an error-level message.
    static func error(
        _ message: @autoclosure () -> String,
        type: ErrorTypeModel,
        original: Error? = nil,
        additionalInfo: [String: String]? = nil
    ) {
        log(
            message(),
            level: .error,
            type: type,
            original: original,
            metadata: additionalInfo
        )
    }

    /// Shortcut for logging an info-level message.
    static func info(_ message: @autoclosure () -> String) {
        log(message(), level: .info)
    }

    /// Shortcut for logging a debug-level message.
    static func debug(_ message: @autoclosure () -> String) {
        log(message(), level: .debug)
    }

    /// Shortcut for logging a warning-level message.
    static func warning(_ message: @autoclosure () -> String) {
        log(message(), level: .warning)
    }

    /// Shortcut for logging a verbose-level message.
    static func verbose(_ message: @autoclosure () -> String) {
        log(message(), level: .verbose)
    }

    // MARK: - Private Helpers
    
    /// Converts `LogLevel` to a corresponding `DDLogFlag`.
    private static func logFlag(for level: LogLevel) -> DDLogFlag {
        switch level {
        case .info:     return .info
        case .debug:    return .debug
        case .warning:  return .warning
        case .error:    return .error
        case .verbose:  return .verbose
        }
    }
}
