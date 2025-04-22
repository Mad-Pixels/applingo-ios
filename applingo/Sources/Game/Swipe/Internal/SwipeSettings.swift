import SwiftUI

class SwipeSettings: GameSettings {
    private(set) var timeDurationSetting: GameSettingItemInt
    private(set) var countLivesSetting: GameSettingItemInt
    
    /// Initialize the Swipe settings
    init() {
        countLivesSetting = GameSettingItemInt(
            id: "countLives",
            name: LocaleManager.shared.localizedString(for: "settings.game.lives"),
            defaultValue: AppStorage.shared.gameLives,
            options: AVAILABLE_LIVES,
            onChange: { newValue in
                AppStorage.shared.gameLives = newValue
            }
        )
        
        timeDurationSetting = GameSettingItemInt(
            id: "timeDuration",
            name: LocaleManager.shared.localizedString(for: "settings.game.timeDuration"),
            defaultValue: AppStorage.shared.gameDuration,
            options: AVAILABLE_TIME_DURATIONS,
            onChange: { newValue in
                AppStorage.shared.gameDuration = newValue
            }
        )
        
        super.init(settings: [
            timeDurationSetting,
            countLivesSetting
        ])
    }
    
    var gameLives: Int {
        get { getValue(id: "countLives") as? Int ?? DEFAULT_SURVIVAL_LIVES }
        set { setValue(id: "countLives", value: newValue) }
    }

    var gameDuration: Int {
        get { getValue(id: "timeDuration") as? Int ?? DEFAULT_TIME_DURATION }
        set { setValue(id: "timeDuration", value: newValue) }
    }
}
