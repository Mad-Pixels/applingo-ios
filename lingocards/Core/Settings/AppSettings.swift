import Foundation
import Combine

class AppSettings: ObservableObject, Codable {
    @Published var language: String
    @Published var sendLogs: Bool
    @Published var theme: String

    enum CodingKeys: String, CodingKey {
        case language, theme, sendLogs
    }

    init(language: String, theme: String, sendLogs: Bool) {
        self.language = language
        self.sendLogs = sendLogs
        self.theme = theme
    }

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
        try container.encode(sendLogs, forKey: .sendLogs)
        try container.encode(theme, forKey: .theme)
    }
    
    static let `default` = AppSettings(language: getDefaultLanguage(), theme: "light", sendLogs: true)

    static var supportedLanguages: [String] {
        return Bundle.main.localizations.filter { $0 != "Base" }
    }

    static func getDefaultLanguage() -> String {
        let preferredLanguages = Locale.preferredLanguages
        if let matchingLanguage = preferredLanguages.first(where: { language in
            let languageCode = getLanguageCode(from: language)
            return supportedLanguages.contains(languageCode)
        }) {
            return getLanguageCode(from: matchingLanguage)
        }
        return "en"
    }

    private static func getLanguageCode(from language: String) -> String {
        if #available(iOS 16, *) {
            return Locale(identifier: language).language.languageCode?.identifier ?? "en"
        } else {
            return Locale(identifier: language).languageCode ?? "en"
        }
    }
}
