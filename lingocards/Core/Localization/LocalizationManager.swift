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

    private var settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private var bundle: Bundle?

    init(logger: any LoggerProtocol, settingsManager: any SettingsManagerProtocol) {
        self.currentLanguageCode = settingsManager.settings.language
        self.settingsManager = settingsManager
        self.logger = logger

        self.setLanguage(currentLanguageCode)
        setupBindings()
    }

    private func setupBindings() {
        settingsManager.settingsPublisher
            .map { $0.language }
            .removeDuplicates()
            .sink { [weak self] language in
                self?.setLanguage(language)
            }
            .store(in: &cancellables)
    }

    func setLanguage(_ language: String) {
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            logger.log("Failed to load bundle for language: \(language)", level: .error, details: nil)
            return
        }

        self.currentLanguageCode = language
        self.bundle = bundle
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
