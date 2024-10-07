import Foundation
import CocoaLumberjackSwift

struct Logger {
    enum LogLevel {
        case info, debug, warning, error, verbose

        var lumberjackLevel: DDLogLevel {
            switch self {
            case .info: return .info
            case .debug: return .debug
            case .warning: return .warning
            case .error: return .error
            case .verbose: return .verbose
            }
        }
    }

    static func initializeLogger() {
        DDLog.removeAllLoggers()
        let consoleLogger = DDOSLogger.sharedInstance
        DDLog.add(consoleLogger, with: .debug)
    }

    static func log(_ message: @autoclosure () -> String,
                    level: LogLevel = .info,
                    errorType: ErrorType? = nil,
                    additionalInfo: [String: String]? = nil) {
        let messageString = message()

        let logMessage = DDLogMessage(
            format: "%@",
            args: getVaList([messageString]),
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
        DDLog.sharedInstance.log(asynchronous: true, message: logMessage)

        if level == .error, let errorType = errorType, LogHandler.shared.sendLogs {
            LogHandler.shared.sendError(
                messageString,
                type: errorType,
                additionalInfo: additionalInfo
            )
        }
    }

    static func error(_ message: @autoclosure () -> String,
                      type: ErrorType,
                      additionalInfo: [String: String]? = nil) {
        log(message(), level: .error, errorType: type, additionalInfo: additionalInfo)
    }

    static func info(_ message: @autoclosure () -> String) {
        log(message(), level: .info)
    }

    static func debug(_ message: @autoclosure () -> String) {
        log(message(), level: .debug)
    }

    static func warning(_ message: @autoclosure () -> String) {
        log(message(), level: .warning)
    }

    static func verbose(_ message: @autoclosure () -> String) {
        log(message(), level: .verbose)
    }

    private static func logFlag(for level: LogLevel) -> DDLogFlag {
        switch level {
        case .info: return .info
        case .debug: return .debug
        case .warning: return .warning
        case .error: return .error
        case .verbose: return .verbose
        }
    }
}
