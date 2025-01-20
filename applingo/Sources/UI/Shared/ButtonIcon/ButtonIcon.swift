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
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay(
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: style.cornerRadius)
                        .strokeBorder(.clear, lineWidth: 5)
                        .background(
                            DynamicPalette(
                                model: DynamicPaletteModel(colors: [
                                    Color(red: 0.9, green: 0.7, blue: 0.9),
                                    Color(red: 0.7, green: 0.9, blue: 0.9),
                                    Color(red: 0.9, green: 0.9, blue: 0.7)
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
