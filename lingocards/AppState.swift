import SwiftUI
import Combine

class AppState: ObservableObject {
    let logger: Logger
    let apiManager: APIManager
    let databaseManager: DatabaseManagerProtocol
    var settingsManager: SettingsManager
    let localizationManager: LocalizationManager
    let themeManager: ThemeManager

    static var shared: AppState?

    init() {
        // Инициализируем SettingsManager.
        self.settingsManager = SettingsManager()

        // Инициализируем Logger, передавая settingsManager.
        self.logger = Logger(settingsManager: settingsManager)

        // Устанавливаем Logger в SettingsManager.
        self.settingsManager.logger = logger

        // Инициализируем остальные компоненты.
        self.apiManager = APIManager(
            baseURL: "https://lingocards-api.madpixels.io",
            token: "t9DbIipRtzPBVXYLoXxc6KSn",
            logger: logger
        )
        self.databaseManager = DatabaseManager(dbName: "LingoCards.sqlite", logger: logger)
        self.localizationManager = LocalizationManager(logger: logger, settingsManager: settingsManager)
        self.themeManager = ThemeManager(logger: logger, settingsManager: settingsManager)

        // Инициализируем LocalizationService
        LocalizationService.shared.manager = localizationManager

        AppState.shared = self

        setup()
    }

    private func setup() {
        settingsManager.loadSettings()

        do {
            try databaseManager.connect()
            logger.log("База данных успешно подключена", level: .info, details: nil)
        } catch {
            logger.log("Не удалось подключиться к базе данных: \(error.localizedDescription)", level: .error, details: nil)
        }
    }
}
