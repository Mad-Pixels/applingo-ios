import Foundation

protocol SettingsManagerProtocol {
    var settings: AppSettings { get set }
    func loadSettings()
    func saveSettings()
}

class SettingsManager: SettingsManagerProtocol {
    private let userDefaults = UserDefaults.standard
    private let settingsKey = "AppSettings"
    private let logger: LoggerProtocol
    
    var settings: AppSettings {
        didSet {
            saveSettings()
        }
    }
    
    init(logger: LoggerProtocol) {
        self.settings = AppSettings.default
        self.logger = logger
    }
    
    func loadSettings() {
        if let data = userDefaults.data(forKey: settingsKey),
           let savedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
            self.settings = savedSettings
        }
    }
    
    func saveSettings() {
        if let encodedSettings = try? JSONEncoder().encode(settings) {
            userDefaults.set(encodedSettings, forKey: settingsKey)
        }
    }
}
