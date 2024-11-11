import SwiftUI

struct MenuButton: View {
    let title: LocalizedStringKey
    let icon: String
    let action: () -> Void
    
    init(
        _ title: String,
        icon: String,
        action: @escaping () -> Void = {}
    ) {
        self.title = LocalizedStringKey(title)
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(width: UIScreen.main.bounds.width - 80)
            .foregroundColor(theme.baseTextColor)
        }
    }
}
