import SwiftUI

struct CompEmptyListView: View {
    let message: String
    let theme = ThemeManager.shared.currentThemeStyle
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "rectangle.stack.badge.plus")
                .font(.system(size: 70))
                .foregroundColor(theme.accentPrimary)
                .padding(.bottom, 8)
            Text(message)
                .font(.title2.weight(.medium))
                .foregroundColor(theme.textPrimary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Circle()
                .fill(theme.accentPrimary.opacity(0.05))
                .frame(width: 300, height: 300)
                .blur(radius: 50)
        )
    }
}
