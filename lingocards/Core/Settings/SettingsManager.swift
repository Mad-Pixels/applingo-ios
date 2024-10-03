import Foundation
import Combine

protocol SettingsManagerProtocol: ObservableObject {
    var logger: LoggerProtocol? { get set }
    var settings: AppSettings { get set }
    
    var settingsPublisher: Published<AppSettings>.Publisher { get }
    
    func loadSettings()
    func saveSettings()
}

class SettingsManager: ObservableObject, SettingsManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "AppSettings"

    @Published var settings: AppSettings {
        didSet {
            saveSettings()
        }
    }

    var settingsPublisher: Published<AppSettings>.Publisher {
        $settings
    }
    var logger: LoggerProtocol?

    init() {
        self.settings = AppSettings.default
        loadSettings()
    }

    func loadSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let savedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = savedSettings
            logger?.log("Settings was updated", level: .info, details: nil)
        } else {
            logger?.log("Use default settings", level: .info, details: nil)
        }
    }

    func saveSettings() {
        if let encodedSettings = try? JSONEncoder().encode(settings) {
            userDefaults.set(encodedSettings, forKey: settingsKey)
            logger?.log("Settings changes was saved", level: .info, details: nil)
        } else {
            logger?.log("Error while saving settings", level: .error, details: nil)
        }
    }
}
