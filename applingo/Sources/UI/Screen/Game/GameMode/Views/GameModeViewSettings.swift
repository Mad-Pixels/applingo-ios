import SwiftUI

internal struct GameModeViewSettings: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    private let settings: GameSettings

    /// Initialize the GameModeViewSettings.
    init(settings: GameSettings) {
        self.settings = settings
    }
    
    var body: some View {
        if settings.hasSettings {
            VStack() {
                ForEach(settings.getAllSettings(), id: \.id) { setting in
                    if let boolSetting = setting as? BooleanSettingItemBoolean {
                        GameSettingsViewBoolean(setting: boolSetting)
                    }
                }
            }
        }
    }
}
