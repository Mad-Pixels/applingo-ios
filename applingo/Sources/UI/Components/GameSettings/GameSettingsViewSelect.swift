import SwiftUI

struct GameSettingsViewSelect<V: Hashable & CustomStringConvertible>: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @ObservedObject var setting: GameSettingItemSelect<V>

    var body: some View {
        Menu {
            ForEach(setting.options, id: \.self) { value in
                Button(action: {
                    setting.setValue(value)
                }) {
                    HStack {
                        Text(value.description)
                        if value == setting.value {
                            Spacer()
                            Image(systemName: "checkmark")
                        }
                    }
                }
            }
        } label: {
            HStack {
                DynamicText(
                    model: DynamicTextModel(text: setting.name),
                    style: .textGame(
                        themeManager.currentThemeStyle,
                        alignment: .leading
                    )
                )
                
                Spacer()
                
                DynamicText(
                    model: DynamicTextModel(text: setting.value.description),
                    style: .textGame(
                        themeManager.currentThemeStyle,
                        alignment: .trailing
                    )
                )
                
                Image(systemName: "chevron.down")
                    .foregroundColor(themeManager.currentThemeStyle.accentPrimary)
            }
            .padding(12)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(themeManager.currentThemeStyle.backgroundPrimary)
            )
        }
    }
}
