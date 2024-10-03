import Foundation

/// Протокол, определяющий функциональность менеджера локализации
protocol LocalizationManagerProtocol {
    /// Устанавливает текущий язык для локализации
    /// - Parameter language: Код языка (например, "en" или "ru")
    func setLanguage(_ language: String)
    
    /// Возвращает локализованную строку для заданного ключа
    /// - Parameters:
    ///   - key: Ключ локализации
    ///   - arguments: Аргументы для форматирования строки (если есть)
    /// - Returns: Локализованная строка
    func localizedString(for key: String, arguments: CVarArg...) -> String
    
    /// Возвращает текущий установленный язык
    /// - Returns: Код текущего языка
    func currentLanguage() -> String
}

/// Реализация менеджера локализации
class LocalizationManager: LocalizationManagerProtocol {
    private let logger: LoggerProtocol
    private var bundle: Bundle?
    private var currentLanguageCode: String
    
    /// Инициализатор
    /// - Parameter logger: Протокол для логирования
    init(logger: LoggerProtocol) {
        self.logger = logger
        self.currentLanguageCode = Locale.current.languageCode ?? "en"
        self.setLanguage(self.currentLanguageCode)
    }
    
    func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            logger.log("Failed to set language: \(language)", level: .error, details: nil)
            return
        }
        self.bundle = bundle
        self.currentLanguageCode = language
        logger.log("Language set to: \(language)", level: .info, details: nil)
    }
    
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: "Localizable") ?? key
        return String(format: format, arguments: arguments)
    }
    
    func currentLanguage() -> String {
        return currentLanguageCode
    }
}

/// Синглтон для доступа к менеджеру локализации
class LocalizationService {
    static let shared = LocalizationService()
    var manager: LocalizationManagerProtocol?
    
    private init() {}
}

// MARK: - Удобное расширение для использования локализации
extension String {
    /// Возвращает локализованную версию строки
    /// - Parameter arguments: Аргументы для форматирования строки (если есть)
    /// - Returns: Локализованная строка
    func localized(arguments: CVarArg...) -> String {
        guard let manager = LocalizationService.shared.manager else {
            return self
        }
        return manager.localizedString(for: self, arguments: arguments)
    }
}

/// Расширение для AppState для настройки локализации
extension AppState {
    /// Настраивает локализацию для приложения
    func setupLocalization() {
        LocalizationService.shared.manager = self.localizationManager
    }
}
