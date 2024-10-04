import SwiftUI
import Combine

protocol ThemeManagerProtocol: ObservableObject {
    var currentTheme: Theme { get }
    func toggleTheme()
}

class ThemeManager: ObservableObject, ThemeManagerProtocol {
    @Published private(set) var currentTheme: Theme
    
    private let settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    private let logger: LoggerProtocol

    init(logger: any LoggerProtocol, settingsManager: any SettingsManagerProtocol) {
        self.settingsManager = settingsManager
        self.logger = logger
        
        let initialTheme = settingsManager.settings.theme
        switch initialTheme {
        case "dark":
            self.currentTheme = DarkTheme()
        default:
            self.currentTheme = LightTheme()
        }
        
        applyTheme()
        setupBindings()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    func toggleTheme() {
        let newTheme = currentTheme is LightTheme ? "dark" : "light"
        settingsManager.settings.theme = newTheme
    }

    private func setupBindings() {
        settingsManager.settingsPublisher
            .map { $0.theme }
            .removeDuplicates()
            .sink { [weak self] theme in
                self?.setTheme(theme)
            }
            .store(in: &cancellables)
    }

     func setTheme(_ theme: String) {
        switch theme {
        case "dark":
            currentTheme = DarkTheme()
        default:
            currentTheme = LightTheme()
        }
        logger.log("New theme selected: \(theme)", level: .info, details: nil)
        applyTheme()
    }

    private func applyTheme() {}
}
