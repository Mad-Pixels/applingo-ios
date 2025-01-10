import SwiftUI

struct FloatingButtonPreview: View {
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
            
            // Single Button
            FloatingButtonSingle(
                icon: "heart.fill",
                action: { print("Single pressed") },
                style: .themed(theme)
            )
            .frame(height: 200)
            .background(theme.backgroundSecondary)
            .cornerRadius(12)
            
            // Multiple Buttons
            FloatingButtonMultiple(
                items: [
                    IconAction(icon: "heart.fill") { print("Heart!") },
                    IconAction(icon: "bookmark.fill") { print("Bookmark!") },
                    IconAction(icon: "paperplane.fill") { print("Paper plane!") }
                ],
                style: .themed(theme)
            )
            .frame(height: 300)
            .background(theme.backgroundSecondary)
            .cornerRadius(12)
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Floating Button Styles") {
    FloatingButtonPreview()
}
