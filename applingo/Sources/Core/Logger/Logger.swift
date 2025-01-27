import CocoaLumberjackSwift
import Foundation

/// A logger wrapper built on top of CocoaLumberjack,
/// providing convenience methods and an option to send errors to the server via LogHandler.
struct Logger {
    // MARK: - Properties
    
    private static let isInitialized = AtomicBoolean(false)
    
    #if DEBUG
    static var minimumLogLevel: LogLevel = .debug
    #else
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
    ///   - level: The `LogLevel` for the message.
    ///   - type: An optional `ErrorTypeModel` if this log represents an error.
    ///   - original: An optional Swift `Error` object.
    ///   - metadata: Additional metadata for the log.
    ///   - file: The file where the log was called (automatically filled).
    ///   - func: The function where the log was called (automatically filled).
    ///   - line: The line where the log was called (automatically filled).
    static func log(
        _ message: @autoclosure () -> String,
        level: LogLevel = .info,
        type: ErrorTypeModel? = nil,
        original: Error? = nil,
        metadata: [String: String]? = nil,
        
        function: String = #function,
        file: String = #file,
        line: UInt = #line
    ) {
        guard level.rawValue >= minimumLogLevel.rawValue else { return }
        
        let resolvedMessage = message()
        let formattedMessage = "\(resolvedMessage)\(formatMetadata(metadata))"
        
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
        additionalInfo: [String: String]? = nil,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(
            message(),
            level: .error,
            type: type,
            original: original,
            metadata: additionalInfo,
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
        log(message(), level: .info, function: function, file: file,  line: line)
    }

    /// Shortcut for logging a debug-level message.
    static func debug(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .debug, function: function, file: file,  line: line)
    }

    /// Shortcut for logging a warning-level message.
    static func warning(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .warning, function: function, file: file,  line: line)
    }

    /// Shortcut for logging a verbose-level message.
    static func verbose(
        _ message: @autoclosure () -> String,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        log(message(), level: .verbose, function: function, file: file,  line: line)
    }
    
    // MARK: - Private Helpers
    
    /// Форматирует метаданные в строку для добавления к сообщению лога.
    /// Метаданные полезны для:
    /// - Добавления контекста к сообщению (например, ID пользователя, версия приложения)
    /// - Фильтрации и поиска в логах
    /// - Группировки связанных событий
    /// - Отправки дополнительной информации на сервер при ошибках
    private static func formatMetadata(_ metadata: [String: String]?) -> String {
        guard let metadata = metadata, !metadata.isEmpty else { return "" }
        return " | Metadata: " + metadata.map { "\($0.key)=\($0.value)" }.joined(separator: ", ")
    }
}
