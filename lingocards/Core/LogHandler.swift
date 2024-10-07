import Foundation
import UIKit

enum ErrorType: String, Codable {
    case database = "database"
    case network = "network"
    case unknown = "unknown"
    case api = "api"
    case ui = "ui"
}

struct ErrorLog: Codable {
    let errorType: ErrorType
    let errorMessage: String
    let appVersion: String
    let osVersion: String
    let device: String
    let timestamp: Int
    let additionalInfo: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case additionalInfo = "additional_info"
        case errorMessage = "error_message"
        case appVersion = "app_version"
        case osVersion = "os_version"
        case errorType = "error_type"
        case timestamp
        case device
    }

    init(
        errorType: ErrorType,
        errorMessage: String,
        additionalInfo: [String: String]? = nil
    ) {
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        self.timestamp = Int(Date().timeIntervalSince1970)
        self.osVersion = UIDevice.current.systemVersion
        self.device = UIDevice.current.model

        self.errorType = errorType
        self.additionalInfo = additionalInfo
        self.errorMessage = errorMessage
    }

    func toJSON() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        guard let jsonData = try? encoder.encode(self) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

    var description: String {
        var additionalInfoString = "None"
        if let additionalInfo = additionalInfo {
            additionalInfoString = additionalInfo.map { "\($0.key): \($0.value)" }
                .joined(separator: ", ")
        }
        return """
        [ErrorLog]
        Timestamp: \(timestamp)
        OS Version: \(osVersion)
        Device: \(device)
        App Version: \(appVersion)
        Error Type: \(errorType.rawValue)
        Error Message: \(errorMessage)
        Additional Info: \(additionalInfoString)
        """
    }
}

struct LogHandler {
    static func sendLog(_ log: ErrorLog) {
        print("Log ready to send: \(log.description)")

        if let jsonData = try? JSONEncoder().encode(log),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Sending log to server: \(jsonString)")
            // implement http sender here
        }
    }
    
    static func sendError(_ message: String, type: ErrorType, additionalInfo: [String: String]? = nil) {
        let log = ErrorLog(
            errorType: type,
            errorMessage: message,
            additionalInfo: additionalInfo
        )
        sendLog(log)
    }
}
