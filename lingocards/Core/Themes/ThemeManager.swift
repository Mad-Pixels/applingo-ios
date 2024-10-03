// ThemeManager.swift
import SwiftUI
import Combine

protocol ThemeManagerProtocol: ObservableObject {
    var currentTheme: Theme { get }
    func toggleTheme()
}

class ThemeManager: ObservableObject, ThemeManagerProtocol {
    @Published private(set) var currentTheme: Theme
    private let logger: LoggerProtocol
    private let settingsManager: any SettingsManagerProtocol
    private var cancellables = Set<AnyCancellable>()

    init(logger: LoggerProtocol, settingsManager: any SettingsManagerProtocol) {
        self.logger = logger
        self.settingsManager = settingsManager
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

    private func setupBindings() {
        settingsManager.settingsPublisher
            .map { $0.theme }
            .removeDuplicates()
            .sink { [weak self] theme in
                self?.setTheme(theme)
            }
            .store(in: &cancellables)
    }

    private func setTheme(_ theme: String) {
        switch theme {
        case "dark":
            currentTheme = DarkTheme()
        default:
            currentTheme = LightTheme()
        }
        logger.log("Тема изменена на \(theme)", level: .info, details: nil)
        applyTheme()
    }

    func toggleTheme() {
        let newTheme = currentTheme is LightTheme ? "dark" : "light"
        settingsManager.settings.theme = newTheme
    }

    private func applyTheme() {
        // Применение темы к UI, если необходимо
    }
}
