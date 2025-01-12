import SwiftUI

#Preview("Button Component") {
    ButtonPreview()
}

private struct ButtonPreview: View {
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
            
            Group {
                // Action buttons
                VStack(alignment: .leading, spacing: 8) {
                    Text("Action Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonAction(
                        title: "Confirm Action",
                        type: .action,
                        style: .themed(theme, type: .action)
                    ) {
                        print("Action tapped")
                    }
                    
                    ButtonAction(
                        title: "Disabled Action",
                        type: .action,
                        style: .themed(theme, type: .action)
                    ) {}
                        .disabled(true)
                }
                
                // Cancel buttons
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cancel Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonAction(
                        title: "Cancel Action",
                        type: .cancel,
                        style: .themed(theme, type: .cancel)
                    ) {
                        print("Cancel tapped")
                    }
                    
                    ButtonAction(
                        title: "Disabled Cancel",
                        type: .cancel,
                        style: .themed(theme, type: .cancel)
                    ) {}
                        .disabled(true)
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}
