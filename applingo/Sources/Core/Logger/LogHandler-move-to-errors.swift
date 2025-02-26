import Foundation
//// MARK: - MOVE TO ERROR IMPLEMENTATION !!!!!!
/////// MARK: - MOVE TO ERROR IMPLEMENTATION !!!!!!
final class LogHandler: ObservableObject {
    static let shared = LogHandler()
    
    @Published var sendLogs: Bool {
        didSet {
            if AppStorage.shared.sendLogs != sendLogs {
                AppStorage.shared.sendLogs = sendLogs
                Logger.debug("[LogHandler]: Updated sendLogs to \(sendLogs) in UserDefaults")
                }
            }
        }
    
        private init() {
            self.sendLogs = AppStorage.shared.sendLogs
        }
}

//import CocoaLumberjackSwift
//import Combine
//
//
//

//
//
//
//struct ErrorLog: Codable {
//    let errorType: ErrorTypeModel
//    let errorMessage: String
//    let errorOriginal: String
//    let appVersion: String
//    let osVersion: String
//    let replicaID: String
//    let device: String
//    let timestamp: Int
//    let additionalInfo: [String: String]?
//
//    enum CodingKeys: String, CodingKey {
//        case replicaID         = "app_identifier"
//        case appVersion        = "app_version"
//        case osVersion         = "device_os"
//        case device            = "device_name"
//        case additionalInfo    = "metadata"
//        case errorOriginal     = "error_original"
//        case errorMessage      = "error_message"
//        case errorType         = "error_type"
//        case timestamp
//    }
//
//    init(
//        errorType: ErrorTypeModel,
//        errorMessage: String,
//        errorOriginal: Error?,
//        additionalInfo: [String: String]? = nil
//    ) {
//        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
//        self.timestamp = Int(Date().timeIntervalSince1970)
//        self.osVersion = UIDevice.current.systemVersion
//        self.device = UIDevice.current.model
//        self.replicaID = AppStorage.shared.appId
//        
//        self.errorType = errorType
//        self.errorMessage = errorMessage
//        self.errorOriginal = errorOriginal.map { String(describing: $0) } ?? "unknown"
//        self.additionalInfo = additionalInfo
//    }
//
//    /// Encodes the log to JSON string if possible.
//    func toJSON() -> String? {
//        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
//        guard let jsonData = try? encoder.encode(self) else { return nil }
//        return String(data: jsonData, encoding: .utf8)
//    }
//
//    /// Human-readable representation, useful for console logging.
//    var description: String {
//        var additionalInfoString = "None"
//        if let additionalInfo {
//            additionalInfoString = additionalInfo
//                .map { "\($0.key): \($0.value)" }
//                .joined(separator: ", ")
//        }
//        return """
//        [ErrorLog]
//        Timestamp: \(timestamp)
//        OS Version: \(osVersion)
//        Device: \(device)
//        App Version: \(appVersion)
//        Error Type: \(errorType.rawValue)
//        Error Message: \(errorMessage)
//        Replica ID: \(replicaID)
//        Additional Info: \(additionalInfoString)
//        """
//    }
//}
//
//// MARK: - LogHandler
//
///// Responsible for sending logs to a remote server if needed.
///// Uses `ErrorLog` as the payload for error logs.
//final class LogHandler: ObservableObject {
//    
//    /// Shared singleton instance.
//    static let shared = LogHandler()
//    
//    @Published var sendLogs: Bool {
//        didSet {
//            if AppStorage.shared.sendLogs != sendLogs {
//                AppStorage.shared.sendLogs = sendLogs
//                Logger.debug("[LogHandler]: Updated sendLogs to \(sendLogs) in UserDefaults")
//            }
//        }
//    }
//
//    private var cancellables = Set<AnyCancellable>()
//    
//    // MARK: - Initialization
//
//    /// Private initializer for singleton pattern.
//    private init() {
//        self.sendLogs = AppStorage.shared.sendLogs
//        observeSendLogs()
//    }
//    
//    /// Observes changes to `sendLogs` property and updates `AppStorage` accordingly.
//    private func observeSendLogs() {
//        $sendLogs
//            .sink { newValue in
//                Logger.debug("[LogHandler]: SendLogs changed to \(newValue)")
//                AppStorage.shared.sendLogs = newValue
//            }
//            .store(in: &cancellables)
//    }
//    
//    // MARK: - Public Methods
//
//    /// Sends a generic `ErrorLog` payload to the server.
//    /// If `sendLogs` is disabled, the log is printed to console and not sent.
//    func sendLog(_ log: ErrorLog) {
//        guard sendLogs else {
//            Logger.debug("[LogHandler]: Log sending is disabled. Log content: \(log.description)")
//            return
//        }
//
//        Logger.debug("[LogHandler]: Sending log -> \(log.description)")
//        
//        Task {
//            do {
//                let endpoint = "/v1/reports"
//                let body = try JSONEncoder().encode(log)
//
//                _ = try await AppAPI.shared.request(
//                    endpoint: endpoint,
//                    method: .post,
//                    body: body
//                )
//                Logger.debug("[LogHandler]: Log sent successfully")
//            } catch {
//                Logger.debug("[LogHandler]: Failed to send log - Error: \(error.localizedDescription)")
//                if let jsonData = try? JSONEncoder().encode(log),
//                   let jsonString = String(data: jsonData, encoding: .utf8) {
//                    Logger.debug("[LogHandler]: Failed log content: \(jsonString)")
//                }
//            }
//        }
//    }
//    
//    /// Creates and sends an error log built from the given parameters.
//    func sendError(
//        _ message: String,
//        type: ErrorTypeModel,
//        original: Error?,
//        additionalInfo: [String: String]? = nil
//    ) {
//        let log = ErrorLog(
//            errorType: type,
//            errorMessage: message,
//            errorOriginal: original,
//            additionalInfo: additionalInfo
//        )
//        sendLog(log)
//    }
//}
