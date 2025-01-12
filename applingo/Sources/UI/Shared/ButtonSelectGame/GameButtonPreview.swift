import SwiftUI

struct GameButtonPreview_Previews: PreviewProvider {
    static var previews: some View {
        GameButtonPreview()
            .previewDisplayName("Game Button Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct GameButtonPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                previewSection("Light Theme", theme: LightTheme())
                previewSection("Dark Theme", theme: DarkTheme())
            }
            .padding()
        }
    }

    private func previewSection(_ title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            
            GameButton(
                title: "Play Game",
                icon: "gamecontroller.fill",
                style: .themed(theme, color: theme.accentPrimary)
            )
            
            GameButton(
                title: "Settings",
                icon: "gearshape.fill",
                style: .themed(theme, color: theme.success)
            )
        }
        .padding()
        .background(theme.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
