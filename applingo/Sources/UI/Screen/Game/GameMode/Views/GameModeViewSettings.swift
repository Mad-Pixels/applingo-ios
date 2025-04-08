import SwiftUI

internal struct GameModeViewSettings: View {
    @EnvironmentObject private var themeManager: ThemeManager

    private let settings: GameSettings

    init(settings: GameSettings) {
        self.settings = settings
    }

    var body: some View {
        if settings.hasSettings {
            VStack(spacing: 12) {
                ForEach(settings.getAllSettings(), id: \.id) { setting in
                    if let boolSetting = setting as? GameSettingItemBoolean {
                        GameSettingsViewBoolean(setting: boolSetting)
                    } else if let intSetting = setting as? GameSettingItemInt {
                        GameSettingsViewSelect<Int>(setting: intSetting)
                    } else if let timeSetting = setting as? GameSettingItemTime {
                        GameSettingsViewSelect<TimeInterval>(setting: timeSetting)
                    }
                }
            }
        }
    }
}
