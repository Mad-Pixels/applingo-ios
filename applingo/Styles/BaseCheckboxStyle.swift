import SwiftUI

struct BaseCheckboxStyle: ToggleStyle {
    @Environment(\.isEnabled) private var isEnabled
    private let theme = ThemeManager.shared.currentThemeStyle
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        configuration.isOn ? theme.accentPrimary : theme.accentLight,
                        lineWidth: configuration.isOn ? 0 : 2
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(configuration.isOn ? theme.accentPrimary : .clear)
                    )
                    .frame(width: 26, height: 26)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .opacity(configuration.isOn ? 1 : 0)
                    .scaleEffect(configuration.isOn ? 1 : 0.5)
            }
            .opacity(isEnabled ? 1 : 0.5)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isOn)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
