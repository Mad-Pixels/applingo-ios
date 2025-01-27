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
        guard level.rawValue >= minimumLogLevel.rawValue else {
            return
        }
        
        let resolvedMessage = message()
        let contextInfo = formatContext(function: function, file: file, line: line)
        let metadataInfo = formatMetadata(metadata)
        let formattedMessage = "\(resolvedMessage)\(metadataInfo)\(contextInfo)"
        
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
        log(
            message(),
            level: .error,
            appError: appError,
            metadata: metadata,
            function: function,
            file: file,
            line: line
        )
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
    
    /// Format metadata into a readable string for logging.
    /// Now it's `[String: Any]` to match `AppErrorContext.metadata`.
    private static func formatMetadata(_ metadata: [String: Any]?) -> String {
        guard let metadata = metadata, !metadata.isEmpty else { return "" }
        let pairs = metadata.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
        return " | Metadata: " + pairs
    }
    
    /// Format context information (file, function, line) into a readable string
    private static func formatContext(function: String, file: String, line: UInt) -> String {
        let fileName = (file as NSString).lastPathComponent
        return " | \(fileName):\(line) \(function)"
    }
}
