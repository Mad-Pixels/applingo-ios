import Foundation
import UIKit
import os.log
import Combine

/// Протокол, определяющий методы для логирования.
protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType, details: [String: Any]?)
}

/// Управляет логированием и наблюдает за настройками, чтобы определить, нужно ли отправлять логи на сервер.
class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.LingoCards", category: "AppLogs")
    private var pendingLogs: [String] = []
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(settingsManager: any SettingsManagerProtocol) {
        self.settingsManager = settingsManager
        setupBindings()
    }

    /// Настраивает привязки для наблюдения за изменениями настроек.
    private func setupBindings() {
        settingsManager.settingsPublisher
            .sink { [weak self] _ in
                self?.sendLogsIfNeeded()
            }
            .store(in: &cancellables)
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

    private func sendLogsIfNeeded() {
        if settingsManager.settings.sendLogs {
            for message in pendingLogs {
                sendLogsToServer(message: message, details: nil)
            }
            pendingLogs.removeAll()
        }
    }

    /// Отправляет логи на сервер.
    func sendLogsToServer(message: String, details: [String: Any]? = nil) {
        // Подготавливаем лог-сообщение.
        var logMessage: [String: Any] = ["message": message]
        if let details = details {
            logMessage["details"] = details
        }
        let deviceInfo = getDeviceInfo()
        logMessage["device_info"] = deviceInfo

        // Сериализуем лог-сообщение в JSON.
        guard (try? JSONSerialization.data(withJSONObject: logMessage, options: [])) != nil else {
            print("Не удалось сериализовать лог-сообщение в JSON")
            return
        }

        print("Отправка логов на сервер с сообщением:", message)
        // TODO: Реализуйте фактическую отправку логов через HTTPS.
    }

    /// Получает информацию об устройстве для логирования.
    private func getDeviceInfo() -> [String: Any] {
        let device = UIDevice.current
        let processInfo = ProcessInfo.processInfo

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
