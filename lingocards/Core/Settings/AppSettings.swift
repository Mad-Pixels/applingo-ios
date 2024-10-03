import Foundation

struct AppSettings: Codable {
    var language: String
    var theme: String
    var sendLogs: Bool
    // Добавьте другие настройки по необходимости

    static let `default` = AppSettings(language: "en", theme: "light", sendLogs: false)
}
