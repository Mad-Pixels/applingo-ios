import Foundation
import Combine

/// Класс, представляющий настройки приложения.
class AppSettings: ObservableObject, Codable {
    @Published var language: String
    @Published var theme: String
    @Published var sendLogs: Bool

    enum CodingKeys: String, CodingKey {
        case language, theme, sendLogs
    }

    init(language: String, theme: String, sendLogs: Bool) {
        self.language = language
        self.theme = theme
        self.sendLogs = sendLogs
    }

    /// Реализация протокола Codable для корректной сериализации @Published свойств.
    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let language = try container.decode(String.self, forKey: .language)
        let theme = try container.decode(String.self, forKey: .theme)
        let sendLogs = try container.decode(Bool.self, forKey: .sendLogs)
        self.init(language: language, theme: theme, sendLogs: sendLogs)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(language, forKey: .language)
        try container.encode(theme, forKey: .theme)
        try container.encode(sendLogs, forKey: .sendLogs)
    }

    /// Настройки по умолчанию.
    static let `default` = AppSettings(language: "en", theme: "light", sendLogs: false)
}
