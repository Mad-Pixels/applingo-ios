import Foundation
import UIKit
import os.log
import Combine

// Протокол, определяющий методы для логирования
protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType, details: [String: Any]?)
}

// Класс для управления логированием
class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.LingoCards", category: "AppLogs")
    private var pendingLogs: [String] = []
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(settingsManager: any SettingsManagerProtocol) {
        self.settingsManager = settingsManager
        setupBindings()
    }

    private func setupBindings() {
        settingsManager.settingsPublisher
            .sink { [weak self] (settings: AppSettings) in
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
    
    // Метод для отправки логов на сервер
    func sendLogsToServer(message: String, details: [String: Any]? = nil) {
        // Создаем словарь для лог-сообщения
        var logMessage: [String: Any] = ["message": message]
        
        // Преобразуем детали в строковый формат для безопасной сериализации
        if let details = details {
            logMessage["details"] = details // Сохраняем детали в виде словаря
        }
        
        // Добавление информации о устройстве и операционной системе
        let deviceInfo = getDeviceInfo()
        logMessage["device_info"] = deviceInfo
        
        // Преобразуем лог в JSON-формат
        guard (try? JSONSerialization.data(withJSONObject: logMessage, options: [])) != nil else {
            print("Failed to serialize log message to JSON")
            return
        }
        
        print("Sending logs to server with message:", message)
        if let details = details {
            print("Details:", details)
        }
        
        print("Device Info:", deviceInfo)
        if let details = details {
            print("Details:", details)
        }
        
        // TODO: Реализовать отправку логов на сервер через HTTPS
        // Пример отправки лога:
        // 1. Создать URL и URLRequest.
        // 2. Использовать URLSession для отправки POST-запроса с httpBody.
    }
    
    private func getDeviceInfo() -> [String: Any] {
        let device = UIDevice.current
        let processInfo = ProcessInfo.processInfo
        
        // Информация о устройстве и ОС
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
