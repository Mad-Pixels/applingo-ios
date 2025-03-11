import SwiftUI

// MARK: - ButtonPreview

/// Preview component demonstrating different styles and states of `ButtonAction`.
private struct ButtonPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                previewSection(title: "Light Theme", theme: LightTheme())
                previewSection(title: "Dark Theme", theme: DarkTheme())
            }
            .padding()
        }
    }

    /// Creates a preview section with themed buttons.
    /// - Parameters:
    ///   - title: Title for the theme section.
    ///   - theme: AppTheme applied to the buttons.
    private func previewSection(title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)

            buttonGroup(title: "Action Button", buttonTitle: "Confirm Action", theme: theme, style: .action(theme))

            buttonGroup(title: "Cancel Button", buttonTitle: "Cancel Action", theme: theme, style: .cancel(theme))

            buttonGroup(title: "Disabled Button", buttonTitle: "Disabled Action", theme: theme, style: .action(theme), disabled: true)
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }

    /// Helper method to create grouped button preview.
    private func buttonGroup(
        title: String,
        buttonTitle: String,
        theme: AppTheme,
        style: ButtonActionStyle,
        disabled: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)

            ButtonAction(
                title: buttonTitle,
                action: { print("\(buttonTitle) tapped") },
                disabled: disabled,
                style: style
            )
        }
    }
}

// MARK: - ButtonPreview_Previews

/// SwiftUI previews for ButtonPreview.
struct ButtonPreview_Previews: PreviewProvider {
    static var previews: some View {
        ButtonPreview()
            .previewDisplayName("Button Component Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
