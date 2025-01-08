import SwiftUI

struct CompButtonGameModeView: View {
    let title: String
    let icon: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        let theme = ThemeManager.shared.currentThemeStyle
        
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 30)
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.textSecondary)
            }
            .padding()
            .background(theme.backgroundSecondary.opacity(0.3))
            .cornerRadius(10)
        }
        .foregroundColor(theme.textPrimary)
    }
}
