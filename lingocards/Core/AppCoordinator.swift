import Foundation

protocol AppCoordinatorProtocol {
    var logger: LoggerProtocol { get }
    var apiManager: APIManagerProtocol { get }
    var databaseManager: DatabaseManagerProtocol { get }
    var settingsManager: SettingsManagerProtocol { get }
    var localizationManager: LocalizationManagerProtocol { get }
    var themeManager: ThemeManagerProtocol { get }
    
    func start()
}

class AppCoordinator: AppCoordinatorProtocol {
    let logger: LoggerProtocol
    let apiManager: APIManagerProtocol
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: SettingsManagerProtocol
    let localizationManager: LocalizationManagerProtocol
    let themeManager: ThemeManagerProtocol
    
    init() {
        self.logger = Logger()
        self.apiManager = APIManager(baseURL: "https://lingocards-api.madpixels.io", token: "t9DbIipRtzPBVXYLoXxc6KSn", logger: logger)
        self.databaseManager = DatabaseManager(dbName: "LingoCards.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger)
        self.settingsManager = SettingsManager(logger: logger)
        self.themeManager = ThemeManager(logger: logger)
    }
    
    func start() {
        // Инициализация компонентов
        do {
            try databaseManager.connect()
            logger.log("Database connected successfully", level: .info)
        } catch {
            logger.log("Failed to connect to database: \(error.localizedDescription)", level: .error)
        }
        
        // Загрузка сохраненных настроек
        settingsManager.loadSettings()
        
        // Применение сохраненного языка
        let savedLanguage = settingsManager.settings.language
        localizationManager.setLanguage(savedLanguage)
        
        // Применение сохраненной темы
        let savedTheme = settingsManager.settings.theme
        themeManager.setTheme(savedTheme)
        
        // Дополнительная логика инициализации...
    }
}
