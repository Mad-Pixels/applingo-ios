import SwiftUI
import Combine

class AppState: ObservableObject {
    let logger: LoggerProtocol
    let apiManager: APIManagerProtocol
    let databaseManager: DatabaseManagerProtocol
    let settingsManager: SettingsManager
    let localizationManager: LocalizationManager
    let themeManager: ThemeManager

    init() {
        // 1. Инициализируем SettingsManager без Logger
        self.settingsManager = SettingsManager()

        // 2. Инициализируем Logger, передавая settingsManager
        self.logger = Logger(settingsManager: settingsManager)

        // 3. Устанавливаем Logger в SettingsManager
        self.settingsManager.logger = logger

        // Инициализируем остальные компоненты
        self.apiManager = APIManager(baseURL: "https://lingocards-api.madpixels.io",
                                     token: "t9DbIipRtzPBVXYLoXxc6KSn",
                                     logger: logger)
        self.databaseManager = DatabaseManager(dbName: "LingoCards.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger,
                                                       initialLanguage: settingsManager.settings.language)
        self.themeManager = ThemeManager(logger: logger, initialTheme: settingsManager.settings.theme)

        setup()
    }

    private func setup() {
        setupLocalization()
        settingsManager.loadSettings()
        observeSettingsChanges()

        do {
            try databaseManager.connect()
            logger.log("Database connected successfully", level: .info, details: nil)
        } catch {
            logger.log("Failed to connect to database: \(error.localizedDescription)", level: .error, details: nil)
        }
    }

    private func observeSettingsChanges() {
        settingsManager.$settings
            .sink { [weak self] settings in
                self?.localizationManager.setLanguage(settings.language)
                self?.themeManager.setTheme(settings.theme)
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}
