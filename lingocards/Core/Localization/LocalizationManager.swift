// LocalizationManager.swift
import Foundation
import Combine

/// Протокол, определяющий функциональность менеджера локализации.
protocol LocalizationManagerProtocol {
    func setLanguage(_ language: String)
    func localizedString(for key: String, arguments: CVarArg...) -> String
    func currentLanguage() -> String
}

/// Управляет локализацией, наблюдая за изменениями настроек и обновляясь соответственно.
class LocalizationManager: ObservableObject, LocalizationManagerProtocol {
    private let logger: LoggerProtocol
    private var bundle: Bundle?
    @Published private(set) var currentLanguageCode: String
    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    /// Инициализирует менеджер локализации.
    init(logger: LoggerProtocol, settingsManager: any SettingsManagerProtocol) {
        self.logger = logger
        self.settingsManager = settingsManager
        self.currentLanguageCode = settingsManager.settings.language
        self.setLanguage(currentLanguageCode)
        setupBindings()
    }

    /// Настраивает привязки для наблюдения за изменениями настроек.
    private func setupBindings() {
        settingsManager.settingsPublisher
            .map { $0.language }
            .removeDuplicates()
            .sink { [weak self] language in
                self?.setLanguage(language)
            }
            .store(in: &cancellables)
    }

    /// Устанавливает текущий язык и обновляет бандл.
    func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            logger.log("Не удалось установить язык: \(language)", level: .error, details: nil)
            return
        }
        self.bundle = bundle
        self.currentLanguageCode = language
        logger.log("Язык установлен на: \(language)", level: .info, details: nil)
        
        // Уведомляем об изменениях
        objectWillChange.send()
    }

    func localizedString(for key: String, arguments: CVarArg...) -> String {
        let format = bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
        return String(format: format, arguments: arguments)
    }

    func currentLanguage() -> String {
        return currentLanguageCode
    }
}


extension String {
    func localized(arguments: CVarArg...) -> String {
        guard let manager = LocalizationService.shared.manager else {
            return self
        }
        return manager.localizedString(for: self, arguments: arguments)
    }
}


class LocalizationService {
    static let shared = LocalizationService()
    var manager: LocalizationManagerProtocol?
    
    private init() {}
}

