import SwiftUI

struct GameButton: View {
    let title: String
    let icon: String
    let color: Color
    let style: GameButtonStyle
    let action: () -> Void

    init(
        title: String,
        icon: String,
        color: Color = ThemeManager.shared.currentThemeStyle.accentPrimary,
        action: @escaping () -> Void = {},
        style: GameButtonStyle = .themed(ThemeManager.shared.currentThemeStyle, color: ThemeManager.shared.currentThemeStyle.accentPrimary)
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.style = style
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .trailing) {
                Image(systemName: icon)
                    .font(.system(size: style.iconSize))
                    .rotationEffect(.degrees(style.iconRotation))
                    .foregroundColor(style.iconColor)
                    .frame(width: 100)
                    .offset(x: 25)
                
                HStack {
                    Text(title.uppercased())
                        .font(style.font)
                        .foregroundColor(style.foregroundColor)
                    Spacer()
                }
                .padding(style.padding)
            }
            .frame(maxWidth: .infinity)
            .frame(height: style.height)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
            .scaleEffect(style.highlightOnPress ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: style.highlightOnPress)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
