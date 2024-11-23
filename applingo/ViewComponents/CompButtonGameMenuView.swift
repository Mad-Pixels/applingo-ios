import SwiftUI

struct CompButtonGameMenuView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String,
        color: Color = ThemeManager.shared.currentThemeStyle.accentColor,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    
    var body: some View {
        let theme = themeManager.currentThemeStyle
        
        Button(action: action) {
            ZStack(alignment: .trailing) {
                Image(systemName: icon)
                    .font(.system(size: 75))
                    .rotationEffect(.degrees(45))
                    .foregroundColor(color.opacity(0.7))
                    .frame(width: 100)
                    .offset(x: 25)

                HStack {
                    Text(title.uppercased())
                        .font(.body)
                        .foregroundColor(theme.baseTextColor)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .foregroundColor(theme.baseTextColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .contentShape(Rectangle())
        }
        .buttonStyle(GameMenuButtonStyle(color: color))
    }
}
