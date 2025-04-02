import SwiftUI

struct GameSettingsViewBoolean: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    @ObservedObject var setting: BooleanSettingItemBoolean
    
    var body: some View {
        HStack {
            Toggle(isOn: Binding(
                get: { setting.value },
                set: { newValue in
                    setting.setValue(newValue)
                }
            ))
            {
                DynamicText(
                    model: DynamicTextModel(text: setting.name),
                    style: .textGame(
                        ThemeManager.shared.currentThemeStyle,
                        alignment: .leading
                    )
                )
                .padding(.vertical, 16)
                
            }
            .padding(12)
            .tint(themeManager.currentThemeStyle.accentPrimary)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.currentThemeStyle.backgroundPrimary)
            )
        }
    }
}
