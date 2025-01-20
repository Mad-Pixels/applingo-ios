import SwiftUI

struct ButtonSelectGame_Previews: PreviewProvider {
    static var previews: some View {
        ButtonSelectGamePreview()
            .previewDisplayName("Game Button Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct ButtonSelectGamePreview: View {
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
            
            ButtonIcon(
                title: "Play Game",
                icon: "gamecontroller.fill",
                style: .themed(theme)
            )
            
            ButtonIcon(
                title: "Quiz",
                icon: "gearshape.fill",
                style: .asGameSelect(theme, theme.quizTheme)
            )
        }
        .padding()
        .background(theme.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
