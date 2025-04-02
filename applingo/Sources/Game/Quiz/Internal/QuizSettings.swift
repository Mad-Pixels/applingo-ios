import SwiftUI

class QuizSettings: GameSettings {
    private(set) var noVoiceSetting: BooleanSettingItemBoolean
    
    /// Initialize the Quiz settings
    init() {
        noVoiceSetting = BooleanSettingItemBoolean(
            id: "noVoice",
            name: LocaleManager.shared.localizedString(for: "settings.game.noVoice"),
            defaultValue: AppStorage.shared.noVoice,
            onChange: { newValue in
                AppStorage.shared.noVoice = newValue
            }
        )
        
        super.init(settings: [noVoiceSetting])
    }
    
    var noVoice: Bool {
        get {
            return getValue(id: "noVoice") as? Bool ?? false
        }
        set {
            setValue(id: "noVoice", value: newValue)
        }
    }
}
