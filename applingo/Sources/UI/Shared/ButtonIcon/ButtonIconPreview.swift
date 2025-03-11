import SwiftUI

struct ButtonIcon_Previews: PreviewProvider {
    static var previews: some View {
        ButtonIconPreview()
            .previewDisplayName("Button Navigation Component Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct ButtonIconPreview: View {
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

            ButtonIcon(
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
