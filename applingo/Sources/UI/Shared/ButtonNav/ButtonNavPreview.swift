import SwiftUI

struct ButtonNav_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNavPreview()
            .previewDisplayName("Button Navigation Component Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct ButtonNavPreview: View {
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
                .frame(maxWidth: .infinity, alignment: .leading)

            ButtonNav(
                title: "Game Mode",
                subtitle: "Select your preferred game mode",
                icon: "gamecontroller",
                isSelected: true,
                style: .themed(theme)
            ) {}
        }
        .padding()
    }
}
