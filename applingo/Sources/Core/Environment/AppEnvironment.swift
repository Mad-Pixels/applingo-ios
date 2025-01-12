import SwiftUI

// MARK: - Locale
private struct SettingsLocaleKey: EnvironmentKey {
    static let defaultValue: SettingsLocale = SettingsLocale()
}

extension EnvironmentValues {
    var settingsLocale: SettingsLocale {
        get { self[SettingsLocaleKey.self] }
        set { self[SettingsLocaleKey.self] = newValue }
    }    
}
