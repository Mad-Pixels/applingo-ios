import SwiftUI

struct ButtonPreview_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ButtonPreview()
                .previewDisplayName("Button Component Preview")
                .previewLayout(.sizeThatFits)
                .padding()
                .background(Color(.systemBackground))
        }
    }
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
                .foregroundColor(theme.textPrimary)
            
            Group {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Action Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonAction(
                        title: "Confirm Action",
                        type: .action,
                        action: {
                            print("Action tapped")
                        },
                        style: .themed(theme, type: .action)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Cancel Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonAction(
                        title: "Cancel Action",
                        type: .cancel,
                        action: {
                            print("Cancel tapped")
                        },
                        style: .themed(theme, type: .cancel)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonAction(
                        title: "Disabled Action",
                        type: .disabled,
                        action: {},
                        style: .themed(theme, type: .disabled)
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}
