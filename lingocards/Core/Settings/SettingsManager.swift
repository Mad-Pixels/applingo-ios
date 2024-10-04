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
        func loadSettings() {
            if let data = userDefaults.data(forKey: settingsKey),
               let savedSettings = try? JSONDecoder().decode(AppSettings.self, from: data) {
                self.settings = savedSettings
            } else {
                self.logger?.log("Using default settings", level: .info, details: nil)
            }
        }
    }

    func saveSettings() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            if let encodedSettings = try? JSONEncoder().encode(self.settings) {
                self.userDefaults.set(encodedSettings, forKey: self.settingsKey)
                self.logger?.log("Settings changes were saved", level: .info, details: nil)
            } else {
                self.logger?.log("Error while saving settings", level: .error, details: nil)
            }
        }
    }
}
