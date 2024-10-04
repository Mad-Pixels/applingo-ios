import Foundation
import Combine

protocol LocalizationManagerProtocol {
    func setLanguage(_ language: String)
    func localizedString(for key: String, arguments: CVarArg...) -> String
    func currentLanguage() -> String
}


class LocalizationManager: ObservableObject, LocalizationManagerProtocol {
    @Published private(set) var currentLanguageCode: String
    private let logger: LoggerProtocol
    private var bundle: Bundle?
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(logger: LoggerProtocol, settingsManager: any SettingsManagerProtocol) {
        self.currentLanguageCode = settingsManager.settings.language
        self.logger = logger
        self.settingsManager = settingsManager
        setupBindings()
        setLanguage(currentLanguageCode)
    }

    /// Устанавливаем подписку на изменения языка в `SettingsManager`
    private func setupBindings() {
        settingsManager.settingsPublisher
            .map { $0.language }
            .removeDuplicates()
            .receive(on: DispatchQueue.main) // Обработка изменений на главном потоке
            .sink { [weak self] language in
                self?.setLanguage(language)
            }
            .store(in: &cancellables)
    }

    /// Изменение языка приложения
    func setLanguage(_ language: String) {
        logger.log("Switching to language: \(language)", level: .info, details: nil)

        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            logger.log("Failed to load bundle for language: \(language)", level: .error, details: nil)
            return
        }

        
        self.currentLanguageCode = language
        self.bundle = bundle
        self.logger.log("Language switched to: \(language)", level: .info, details: ["bundlePath": path])
    }

    /// Метод для получения локализованной строки
    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments)
    }

    func currentLanguage() -> String {
        return currentLanguageCode
    }
}
