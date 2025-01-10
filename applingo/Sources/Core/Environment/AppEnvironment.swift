import SwiftUI

private struct SettingsLocaleKey: EnvironmentKey {
    static let defaultValue: ScreenSettingsLocale = ScreenSettingsLocale()
}

extension EnvironmentValues {
    var settingsLocale: ScreenSettingsLocale {
        get { self[SettingsLocaleKey.self] }
        set { self[SettingsLocaleKey.self] = newValue }
    }    
}
