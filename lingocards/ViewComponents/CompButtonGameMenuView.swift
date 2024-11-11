import SwiftUI

struct CompButtonGameMenuView: View {
    @ObservedObject private var themeManager = ThemeManager.shared
    
    let title: String
    let icon: String
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        let theme = themeManager.currentThemeStyle
        
        Button(action: action) {
            ZStack(alignment: .trailing) {
                Image(systemName: icon)
                    .font(.system(size: 100))
                    .rotationEffect(.degrees(45))
                    .foregroundColor(theme.accentColor.opacity(0.7))
                    .frame(width: 100)
                    .offset(x: 20)

                HStack {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .foregroundColor(theme.baseTextColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(GameMenuButtonStyle())
    }
}
