import SwiftUI

class AppState: ObservableObject {
    let logger: LoggerProtocol
    let apiManager: APIManagerProtocol
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: SettingsManagerProtocol
    let localizationManager: LocalizationManagerProtocol
    let themeManager: ThemeManagerProtocol
    
    init() {
        self.logger = Logger(sendLogs: true)
        self.apiManager = APIManager(baseURL: "https://lingocards-api.madpixels.io", token: "t9DbIipRtzPBVXYLoXxc6KSn", logger: logger)
        self.databaseManager = DatabaseManager(dbName: "LingoCards.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger)
        self.settingsManager = SettingsManager(logger: logger)
        self.themeManager = ThemeManager(logger: logger)
        
        setup()
    }
    
    private func setup() {
        do {
            try databaseManager.connect()
            logger.log("Database connected successfully", level: .info, details: nil)
        } catch {
            logger.log("Failed to connect to database: \(error.localizedDescription)", level: .error, details: nil)
        }
        
        settingsManager.loadSettings()
        localizationManager.setLanguage(settingsManager.settings.language)
        themeManager.setTheme(settingsManager.settings.theme)
    }
}
