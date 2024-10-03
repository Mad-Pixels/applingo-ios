import Foundation
import os.log

// Протокол, определяющий методы для логирования
protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType, details: [String: Any]?)
}

// Класс для управления логированием
class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.LingoCards", category: "AppLogs")
    private var pendingLogs: [String] = []
    private var sendLogs: Bool = false
    
    init(sendLogs: Bool) {
        self.sendLogs = sendLogs
    }
    
    // Метод для локального логирования
    func log(_ message: String, level: OSLogType = .default, details: [String: Any]? = nil) {
        os_log("%{public}@", log: log, type: level, message)
        pendingLogs.append(message)
        
        if let details = details {
            let detailsString = details.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
            os_log("Details: %{public}@", log: log, type: .debug, detailsString)
        }
        
        if self.sendLogs && level == .error {
            self.sendLogsToServer(message: message, details: details)
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
        
        // Преобразуем лог в JSON-формат
        guard (try? JSONSerialization.data(withJSONObject: logMessage, options: [])) != nil else {
            print("Failed to serialize log message to JSON")
            return
        }
        
        print("Sending logs to server with message:", message)
        if let details = details {
            print("Details:", details)
        }
        
        // TODO: Реализовать отправку логов на сервер через HTTPS
        // Пример отправки лога:
        // 1. Создать URL и URLRequest.
        // 2. Использовать URLSession для отправки POST-запроса с httpBody.
    }
}
