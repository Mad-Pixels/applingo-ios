import SwiftUI

class MatchSettings: GameSettings {
    private(set) var timeDurationSetting: GameSettingItemTime
    private(set) var countLivesSetting: GameSettingItemInt
    
    /// Initialize the Match settings
    init() {
        countLivesSetting = GameSettingItemInt(
            id: "countLives",
            name: LocaleManager.shared.localizedString(for: "settings.game.lives"),
            defaultValue: AppStorage.shared.gameLives,
            range: DEFAULT_SURVIVAL_LIVES_MIN...DEFAULT_SURVIVAL_LIVES_MAX,
            onChange: { newValue in
                AppStorage.shared.gameLives = newValue
            }
        )
        
        timeDurationSetting = GameSettingItemTime(
            id: "timeDuration",
            name: LocaleManager.shared.localizedString(for: "settings.game.timeDuration"),
            defaultValue: AppStorage.shared.gameDuration,
            range: DEFAULT_TIME_DURATION_MIN...DEFAULT_TIME_DURATION_MAX,
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
        get { getValue(id: "countLives") as? Int ?? DEFAULT_SURVIVAL_LIVES_MIN }
        set { setValue(id: "countLives", value: newValue) }
    }

    var gameDuration: TimeInterval {
        get { getValue(id: "timeDuration") as? TimeInterval ?? DEFAULT_TIME_DURATION_MIN }
        set { setValue(id: "timeDuration", value: newValue) }
    }
}
