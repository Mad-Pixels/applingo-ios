import SwiftUI

struct ButtonIcon: View {
    let title: String
    let icon: String
    let style: ButtonIconStyle
    let action: () -> Void

    init(
        title: String,
        icon: String,
        action: @escaping () -> Void = {},
        style: ButtonIconStyle = .themed(
            ThemeManager.shared.currentThemeStyle,
            color: ThemeManager.shared.currentThemeStyle.accentPrimary
        )
    ) {
        self.title = title
        self.icon = icon
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
            .background(DynamicPalette(
                model: DynamicPaletteModel(colors: [
                    Color(red: 0.6, green: 0.7, blue: 0.75), // Приглушенный голубой
                                        Color(red: 0.75, green: 0.6, blue: 0.7), // Приглушенный розовый
                                        Color(red: 0.7, green: 0.75, blue: 0.65), // Приглушенный зеленый
                                        Color(red: 0.65, green: 0.65, blue: 0.75), // Приглушенный фиолетовый
                                        Color(red: 0.75, green: 0.75, blue: 0.65)
                   
                ]),
                size: CGSize(width: 250, height:  100)
            ))
            .cornerRadius(style.cornerRadius)
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .strokeBorder(.clear, lineWidth: 8)
                        .background(
                            DynamicPalette(
                                model: DynamicPaletteModel(colors: [
                                    Color(red: 0.8, green: 0.9, blue: 0.95), // Светло-голубой
                                    Color(red: 0.95, green: 0.8, blue: 0.9), // Нежно-розовый
                                    Color(red: 0.9, green: 0.95, blue: 0.85), // Светло-зеленый
                                    Color(red: 0.85, green: 0.85, blue: 0.95), // Светло-фиолетовый
                                    Color(red: 0.95, green: 0.95, blue: 0.85) // Светло-кремовый
                                ]),
                                size: CGSize(width: geometry.size.width * 2, height: geometry.size.height * 2)
                            )
                        )
                        .mask(
                            RoundedRectangle(cornerRadius: style.cornerRadius)
                                .strokeBorder(style: StrokeStyle(lineWidth: 5))
                        )
                }
            )
            .scaleEffect(style.highlightOnPress ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: style.highlightOnPress)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
