import CocoaLumberjackSwift
import Foundation

// MARK: - LogLevel Enum

enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    
    // MARK: - Lumberjack Level Mapping
    
    /// Maps the custom `LogLevel` to `DDLogLevel` used by CocoaLumberjack.
    var lumberjackLevel: DDLogLevel {
        switch self {
        case .info:     return .info
        case .debug:    return .debug
        case .error:    return .error
        case .warning:  return .warning
        case .verbose:  return .verbose
        }
    }
    
    // MARK: - Lumberjack Flag Mapping
    
    /// Maps the custom `LogLevel` to `DDLogFlag` used by CocoaLumberjack.
    var flag: DDLogFlag {
        switch self {
        case .info:     return .info
        case .debug:    return .debug
        case .error:    return .error
        case .warning:  return .warning
        case .verbose:  return .verbose
        }
    }
}
