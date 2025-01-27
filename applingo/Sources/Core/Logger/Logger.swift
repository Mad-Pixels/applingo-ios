import CocoaLumberjackSwift
import Foundation

/// A logger wrapper built on top of CocoaLumberjack,
/// providing convenience methods and an option to send errors to the server via LogHandler.
struct Logger {
    // MARK: - Properties
    
    private static let isInitialized = AtomicBoolean(false)
    
    #if DEBUG
    /// On Debug builds, we log from .debug and above
    static var minimumLogLevel: LogLevel = .debug
    #else
    /// On Release builds, we log from .warning and above
    static var minimumLogLevel: LogLevel = .warning
    #endif
    
    // MARK: - Initialization
    
    /// Initializes CocoaLumberjack. Call this once in app lifecycle (e.g., in `AppDelegate`).
    static func initializeLogger() {
        guard !isInitialized.value else { return }
        DDLog.removeAllLoggers()
        let consoleLogger = DDOSLogger.sharedInstance
        DDLog.add(consoleLogger, with: .debug)
        isInitialized.value = true
    }
    
    // MARK: - Logging Methods
    
    /// Generic logging method.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - level: The `LogLevel` for the message (debug, info, warning, error, verbose).
    ///   - appError: An optional `AppError` if you want to link a structured error to this log.
    ///   - metadata: Additional metadata for the log.
    ///   - file: The file where the log was called (automatically filled).
    ///   - function: The function where the log was called (automatically filled).
    ///   - line: The line where the log was called (automatically filled).
    static func log(
        _ message: @autoclosure () -> String,
        level: LogLevel = .info,
        appError: AppError? = nil,
        metadata: [String: Any]? = nil,
        function: String = #function,
        file: String = #file,
        line: UInt = #line
    ) {
        guard level.rawValue >= minimumLogLevel.rawValue else { return }
        
        let formattedMessage = formatLog(
            message: message(),
            level: level,
            appError: appError,
            metadata: metadata,
            file: file,
            function: function,
            line: line
        )
        
        let ddMessage = DDLogMessage(
            message: formattedMessage,
            level: level.lumberjackLevel,
            flag: level.flag,
            context: 0,
            file: file,
            function: function,
            line: line,
            tag: nil,
            options: [.copyFile, .copyFunction],
            timestamp: nil
        )
        
        DDLog.sharedInstance.log(asynchronous: true, message: ddMessage)
    }
    
    // MARK: - Shortcut methods
    
    /// Shortcut for logging an error-level message with an `AppError`.
    static func error(
        _ message: @autoclosure () -> String,
        appError: AppError? = nil,
        metadata: [String: Any]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .error, appError: appError, metadata: metadata,
            function: function, file: file, line: line)
    }

    /// Shortcut for logging an info-level message.
    static func info(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .info, function: function, file: file, line: line)
    }

    /// Shortcut for logging a debug-level message.
    static func debug(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .debug, function: function, file: file, line: line)
    }

    /// Shortcut for logging a warning-level message.
    static func warning(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .warning, function: function, file: file, line: line)
    }

    /// Shortcut for logging a verbose-level message.
    static func verbose(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .verbose, function: function, file: file, line: line)
    }
    
    // MARK: - Private Helpers
    
    /// Formats the log message with all its components into a readable multi-line string.
    /// The format follows this structure:
    /// LEVEL Message
    /// Source: file:line in function
    /// Error: error description (if present)
    /// Metadata: (if present)
    ///   key: value
    ///   key: value
    private static func formatLog(
        message: String,
        level: LogLevel,
        appError: AppError?,
        metadata: [String: Any]?,
        file: String,
        function: String,
        line: UInt
    ) -> String {
        let fileName = (file as NSString).lastPathComponent
        var components: [String] = []
        
        components.append("Level: \(level)")
        
        components.append("Message: \(message)")
        
        components.append("Source: \(fileName):\(line) in \(function)")
        
        if let error = appError {
            components.append("Error: \(error)")
        }
        
        if let metadata = metadata, !metadata.isEmpty {
            let metadataPairs = metadata.map { "  \($0.key): \($0.value)" }
            components.append("Metadata:")
            components.append(contentsOf: metadataPairs)
        }
        return components.joined(separator: "\n")
    }
}
