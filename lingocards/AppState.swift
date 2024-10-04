import SwiftUI
import Combine

class AppState: ObservableObject {
    static let shared = AppState()
    
    @Published var theme: String {
        didSet {
            applyTheme(theme)
            settingsManager.settings.theme = theme
            settingsManager.saveSettings()
        }
    }
    @Published var language: String {
        didSet {
            localizationManager.setLanguage(language)
            settingsManager.settings.language = language
            settingsManager.saveSettings()
        }
    }
    @Published var sendLogs: Bool {
        didSet {
            settingsManager.settings.sendLogs = sendLogs
            settingsManager.saveSettings()
        }
    }
    
    let logger: Logger
    let apiManager: APIManager
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: SettingsManager
    let localizationManager: LocalizationManager
    let themeManager: ThemeManager

    private init() {
        self.settingsManager = SettingsManager()
        self.logger = Logger(settingsManager: settingsManager)
        self.settingsManager.logger = logger
        self.apiManager = APIManager(baseURL: "https://lingocards-api.madpixels.io", token: "t9DbIipRtzPBVXYLoXxc6KSn", logger: logger)
        self.databaseManager = DatabaseManager(dbName: "LingoCards.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger, settingsManager: settingsManager)
        self.themeManager = ThemeManager(logger: logger, settingsManager: settingsManager)

        // Initialize @Published properties from settings
        self.theme = settingsManager.settings.theme
        self.language = settingsManager.settings.language
        self.sendLogs = settingsManager.settings.sendLogs

        // Apply initial theme and language
        applyTheme(theme)
        applyLanguage(language)
        
        do {
            try self.databaseManager.connect()
        } catch {
            logger.log("Failed to connect to the database: \(error)", level: .error, details: nil)
        }
    }

    private func applyTheme(_ theme: String) {
        themeManager.setTheme(theme)
    }

    private func applyLanguage(_ language: String) {
        localizationManager.setLanguage(language)
    }
}
