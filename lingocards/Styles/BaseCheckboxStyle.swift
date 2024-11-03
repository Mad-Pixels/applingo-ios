import SwiftUI

struct BaseCheckboxStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(configuration.isOn ?
                                 ThemeManager().currentThemeStyle.accentColor :
                                    ThemeManager().currentThemeStyle.secondaryIconColor)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
