import SwiftUI

struct BaseCheckboxStyle: ToggleStyle {
    let theme: ThemeStyle

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 28, height: 28)
                .foregroundColor(configuration.isOn ? theme.accentColor : theme.secondaryIconColor)
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
