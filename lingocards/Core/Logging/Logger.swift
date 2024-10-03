import Foundation
import UIKit
import os.log
import Combine

protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType, details: [String: Any]?)
}

class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.LingoCards", category: "AppLogs")

    private var pendingLogs: [String] = []      // Хранит все логи для отображения в UI или отладки
    private var errorLogs: [(message: String, details: [String: Any]?)] = []  // Хранит только ошибки для отправки на сервер
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private let logQueue = DispatchQueue(label: "com.LingoCards.LoggerQueue")

    init(settingsManager: any SettingsManagerProtocol) {
        self.settingsManager = settingsManager
        setupBindings()
    }

    func log(_ message: String, level: OSLogType = .default, details: [String: Any]? = nil) {
        logQueue.async {
            // Записываем лог в локальный системный лог
            os_log("%{public}@", log: self.log, type: level, message)
            self.pendingLogs.append(message)

            // Если есть дополнительные детали, добавляем их в лог
            if let details = details, !details.isEmpty {
                let detailsString = details.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
                os_log("Details: %{public}@", log: self.log, type: .debug, detailsString)
            }

            // Отправляем лог на сервер только если уровень log == .error и отправка логов включена
            if level == .error, self.settingsManager.settings.sendLogs {
                // Отправляем лог на сервер только если детали присутствуют
                self.sendLogsToServer(message: message, details: details)
            }
        }
    }

    func sendLogsToServer(message: String, details: [String: Any]? = nil) {
        logQueue.async { // Обеспечиваем потокобезопасность
            // Проверяем наличие деталей перед отправкой
            guard let details = details, !details.isEmpty else {
                print("Skipping log message: No details to send for message - \(message)")
                return
            }

            var logMessage: [String: Any] = ["message": message]
            logMessage["details"] = details
            let deviceInfo = self.getDeviceInfo()
            logMessage["device_info"] = deviceInfo

            // Печатаем лог вместо реальной отправки на сервер (например, через URLSession)
            print("Send to server log message: \(logMessage)")
            print("Details: \(details)")
            print("Device info: \(deviceInfo)")
        }
    }

    private func sendLogsIfNeeded() {
        logQueue.async {
            // Отправляем только накопленные ошибки (errorLogs), если включена отправка логов
            if self.settingsManager.settings.sendLogs {
                for (message, details) in self.errorLogs {
                    self.sendLogsToServer(message: message, details: details)
                }
                self.errorLogs.removeAll()  // Очищаем отправленные логи ошибок
            }
        }
    }

    private func setupBindings() {
        // Реакция на изменение настроек
        settingsManager.settingsPublisher
            .sink { [weak self] _ in
                self?.sendLogsIfNeeded()  // Отправляем накопленные ошибки, если настройки изменились
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
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
