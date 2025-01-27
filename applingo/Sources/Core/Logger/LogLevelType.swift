import CocoaLumberjackSwift
import Foundation

enum LogLevel: Int {
    case verbose = 0
    case debug = 1
    case info = 2
    case warning = 3
    case error = 4
    
    var lumberjackLevel: DDLogLevel {
        switch self {
        case .info:     return .info
        case .debug:    return .debug
        case .error:    return .error
        case .warning:  return .warning
        case .verbose:  return .verbose
        }
    }
    
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
