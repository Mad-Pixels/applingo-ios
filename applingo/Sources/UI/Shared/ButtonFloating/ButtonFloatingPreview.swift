import SwiftUI

// MARK: - FloatingButtonPreview

/// Preview component demonstrating single and multiple floating buttons in different themes.
private struct FloatingButtonPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                themeSection(title: "Light Theme", theme: LightTheme())
                themeSection(title: "Dark Theme", theme: DarkTheme())
            }
            .padding()
        }
    }

    /// Creates a themed preview section.
    /// - Parameters:
    ///   - title: The title describing the theme.
    ///   - theme: The AppTheme to apply to the preview section.
    private func themeSection(title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)

            singleFloatingButtonPreview(theme: theme)

            multipleFloatingButtonsPreview(theme: theme)
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    /// Preview of a single floating button.
    private func singleFloatingButtonPreview(theme: AppTheme) -> some View {
        VStack(spacing: 8) {
            Text("Single Floating Button")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)

            ButtonFloatingSingle(
                icon: "heart.fill",
                action: { print("Single pressed") },
                style: .themed(theme)
            )
            .frame(height: 200)
            .background(theme.backgroundSecondary)
            .cornerRadius(12)
        }
    }

    /// Preview of multiple floating buttons.
    private func multipleFloatingButtonsPreview(theme: AppTheme) -> some View {
        VStack(spacing: 8) {
            Text("Multiple Floating Buttons")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)

            ButtonFloatingMultiple(
                items: [
                    ButtonFloatingModelIconAction(icon: "heart.fill") { print("Heart!") },
                    ButtonFloatingModelIconAction(icon: "bookmark.fill") { print("Bookmark!") },
                    ButtonFloatingModelIconAction(icon: "paperplane.fill") { print("Paper plane!") }
                ],
                style: .themed(theme)
            )
            .frame(height: 300)
            .background(theme.backgroundSecondary)
            .cornerRadius(12)
        }
    }
}

// MARK: - FloatingButtonPreview_Previews

struct FloatingButtonPreview_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonPreview()
            .previewDisplayName("Floating Button Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
