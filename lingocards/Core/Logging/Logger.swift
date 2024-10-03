import Foundation
import UIKit
import os.log
import Combine

protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType, details: [String: Any]?)
}

class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.LingoCards", category: "AppLogs")

    private var pendingLogs: [String] = []
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(settingsManager: any SettingsManagerProtocol) {
        self.settingsManager = settingsManager
        setupBindings()
    }

    func log(_ message: String, level: OSLogType = .default, details: [String: Any]? = nil) {
        os_log("%{public}@", log: log, type: level, message)
        pendingLogs.append(message)

        if let details = details {
            let detailsString = details.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            os_log("Details: %{public}@", log: log, type: .debug, detailsString)
        }

        if settingsManager.settings.sendLogs && level == .error {
            sendLogsToServer(message: message, details: details)
        }
    }

    func sendLogsToServer(message: String, details: [String: Any]? = nil) {
        var logMessage: [String: Any] = ["message": message]
        if let details = details {
            logMessage["details"] = details
        }
        let deviceInfo = getDeviceInfo()
        logMessage["device_info"] = deviceInfo

        guard (try? JSONSerialization.data(withJSONObject: logMessage, options: [])) != nil else {
            return
        }
        print("Send to server log message: \(logMessage)")
        print("Details: \(details ?? [:])")
        print("Device info: \(deviceInfo)")
    }

    private func sendLogsIfNeeded() {
        if settingsManager.settings.sendLogs {
            for message in pendingLogs {
                sendLogsToServer(message: message, details: nil)
            }
            pendingLogs.removeAll()
        }
    }

    private func setupBindings() {
        settingsManager.settingsPublisher
            .sink { [weak self] _ in
                self?.sendLogsIfNeeded()
            }
            .store(in: &cancellables)
    }

    private func getDeviceInfo() -> [String: Any] {
        let processInfo = ProcessInfo.processInfo
        let device = UIDevice.current

        let deviceInfo: [String: Any] = [
            "device_model": device.model,
            "device_name": device.name,
            "system_name": device.systemName,
            "system_version": device.systemVersion,
            "os_version": processInfo.operatingSystemVersionString,
            "locale": Locale.current.identifier
        ]
        return deviceInfo
    }
}
