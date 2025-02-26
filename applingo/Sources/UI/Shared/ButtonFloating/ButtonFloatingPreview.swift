import SwiftUI

struct FloatingButtonPreview_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButtonPreview()
            .previewDisplayName("Floating Button Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct FloatingButtonPreview: View {
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
            
            VStack {
                Text(verbatim: "Single Floating Button")
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

            VStack {
                Text(verbatim: "Multiple Floating Buttons")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                ButtonFloatingMultiple(
                    items: [
                        ButtonFloatingModelIconAction(
                            icon: "heart.fill"
                        ) { print("Heart!") },
                        ButtonFloatingModelIconAction(
                            icon: "bookmark.fill"
                        ) { print("Bookmark!") },
                        ButtonFloatingModelIconAction(
                            icon: "paperplane.fill"
                        ) { print("Paper plane!") }
                    ],
                    style: .themed(theme)
                )
                .frame(height: 300)
                .background(theme.backgroundSecondary)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
