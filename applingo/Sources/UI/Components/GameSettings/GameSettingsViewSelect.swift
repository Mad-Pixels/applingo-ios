import SwiftUI

struct GameSettingsViewSelect<V: Hashable & CustomStringConvertible>: View {
    @EnvironmentObject private var themeManager: ThemeManager

    @ObservedObject var setting: GameSettingItemSelect<V>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            DynamicText(
                model: DynamicTextModel(text: setting.name),
                style: .textGame(
                    themeManager.currentThemeStyle,
                    alignment: .leading
                )
            )

            Picker(selection: setting.binding(), label: EmptyView()) {
                ForEach(setting.options, id: \.self) { value in
                    Text(value.description)
                        .tag(value)
                }
            }
            .pickerStyle(.segmented)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(themeManager.currentThemeStyle.backgroundPrimary)
        )
    }
}

