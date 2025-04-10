import SwiftUI

class QuizSettings: GameSettings {
    private(set) var timeDurationSetting: GameSettingItemInt
    private(set) var noVoiceSetting: GameSettingItemBoolean
    private(set) var countLivesSetting: GameSettingItemInt
    
    /// Initialize the Quiz settings
    init() {
        noVoiceSetting = GameSettingItemBoolean(
            id: "noVoice",
            name: LocaleManager.shared.localizedString(for: "settings.game.noVoice"),
            defaultValue: AppStorage.shared.noVoice,
            onChange: { newValue in
                AppStorage.shared.noVoice = newValue
            }
        )

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
            countLivesSetting,
            noVoiceSetting
        ])
    }

    var noVoice: Bool {
        get { getValue(id: "noVoice") as? Bool ?? false }
        set { setValue(id: "noVoice", value: newValue) }
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
