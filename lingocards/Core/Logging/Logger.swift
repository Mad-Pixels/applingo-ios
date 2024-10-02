import Foundation
import os.log

// Протокол, определяющий методы для логирования
protocol LoggerProtocol {
    func log(_ message: String, level: OSLogType)
    func sendLogsToServer()
}

// Класс для управления логированием
class Logger: LoggerProtocol {
    private let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "com.yourapp", category: "AppLogs")
    private var pendingLogs: [String] = []
    
    // Метод для локального логирования
    func log(_ message: String, level: OSLogType = .default) {
        os_log("%{public}@", log: log, type: level, message)
        pendingLogs.append(message)
    }
    
    // Метод для отправки логов на сервер
    func sendLogsToServer() {
        // TODO: Реализовать отправку логов на сервер через HTTPS
        // Пример реализации:
        // 1. Сформировать JSON с логами
        // 2. Отправить POST-запрос на сервер логов
        // 3. Очистить pendingLogs после успешной отправки
    }
}
