import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var theme: String
    @Published var language: String
    @Published var sendLogs: Bool
    
    let logger: Logger
    let apiManager: APIManager
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: SettingsManager
    let localizationManager: LocalizationManager
    let themeManager: ThemeManager

    private init() {
        // Initialize SettingsManager
        self.settingsManager = SettingsManager()

        // Initialize Logger
        self.logger = Logger(settingsManager: settingsManager)
        self.settingsManager.logger = logger

        // Initialize other components
        self.apiManager = APIManager(
            baseURL: "https://your-api-url.com",
            token: "your-api-token",
            logger: logger
        )
        self.databaseManager = DatabaseManager(dbName: "YourDatabase.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger, settingsManager: settingsManager)
        self.themeManager = ThemeManager(logger: logger, settingsManager: settingsManager)

        // Load settings
        settingsManager.loadSettings()

        // Initialize @Published properties from settings
        self.theme = settingsManager.settings.theme
        self.language = settingsManager.settings.language
        self.sendLogs = settingsManager.settings.sendLogs

        // Apply initial theme and language
        applyTheme(theme)
        applyLanguage(language)
    }

    func updateTheme(_ newTheme: String) {
        self.theme = newTheme
        settingsManager.settings.theme = newTheme
        settingsManager.saveSettings()
        applyTheme(newTheme)
    }

    func updateLanguage(_ newLanguage: String) {
        self.language = newLanguage
        settingsManager.settings.language = newLanguage
        settingsManager.saveSettings()
        applyLanguage(newLanguage)
    }

    func updateSendLogs(_ newSendLogs: Bool) {
        self.sendLogs = newSendLogs
        settingsManager.settings.sendLogs = newSendLogs
        settingsManager.saveSettings()
    }

     func applyTheme(_ theme: String) {
        themeManager.setTheme(theme)
        // No need to manually notify views; @Published handles it
    }

     func applyLanguage(_ language: String) {
        localizationManager.setLanguage(language)
        // No need to manually notify views; @Published handles it
    }
}
