import Foundation
import CocoaLumberjackSwift

struct Logger {
    enum LogLevel {
        case info, debug, warning, error, verbose

        var lumberjackLevel: DDLogLevel {
            switch self {
            case .info:
                return .info
            case .debug:
                return .debug
            case .warning:
                return .warning
            case .error:
                return .error
            case .verbose:
                return .verbose
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
                    file: StaticString = #file,
                    function: StaticString = #function,
                    line: UInt = #line) {
        let messageString = message()
            
        let logMessage = DDLogMessage(format: "%@",
                                      args: getVaList([messageString]),
                                      level: level.lumberjackLevel,
                                      flag: logFlag(for: level),
                                      context: 0,
                                      file: String(describing: file),
                                      function: String(describing: function),
                                      line: line,
                                      tag: nil,
                                      options: [.copyFile, .copyFunction],
                                      timestamp: nil)
            
        DDLog.sharedInstance.log(asynchronous: true, message: logMessage)
    }

    static func info(_ message: @autoclosure () -> String,
                     file: StaticString = #file,
                     function: StaticString = #function,
                     line: UInt = #line) {
        log(message(), level: .info, file: file, function: function, line: line)
    }

    static func debug(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
        log(message(), level: .debug, file: file, function: function, line: line)
    }

    static func warning(_ message: @autoclosure () -> String,
                        file: StaticString = #file,
                        function: StaticString = #function,
                        line: UInt = #line) {
        log(message(), level: .warning, file: file, function: function, line: line)
    }

    static func error(_ message: @autoclosure () -> String,
                      file: StaticString = #file,
                      function: StaticString = #function,
                      line: UInt = #line) {
        log(message(), level: .error, file: file, function: function, line: line)
    }

    static func verbose(_ message: @autoclosure () -> String,
                        file: StaticString = #file,
                        function: StaticString = #function,
                        line: UInt = #line) {
        log(message(), level: .verbose, file: file, function: function, line: line)
    }

    private static func logFlag(for level: LogLevel) -> DDLogFlag {
        switch level {
        case .info:
            return .info
        case .debug:
            return .debug
        case .warning:
            return .warning
        case .error:
            return .error
        case .verbose:
            return .verbose
        }
    }
}
