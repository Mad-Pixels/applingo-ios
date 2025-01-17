import SwiftUI

struct ButtonNav_Previews: PreviewProvider {
    static var previews: some View {
        ButtonNavPreview()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct ButtonNavPreview: View {
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 32) {
            previewSection("Light Theme", theme: LightTheme())
            previewSection("Dark Theme", theme: DarkTheme())
        }
        .padding()
    }
    
    private func previewSection(_ title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Back Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonNav(
                        style: .back(theme),
                        onTap: { print("Back tapped") },
                        isPressed: $isPressed
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Close Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonNav(
                        style: .close(theme),
                        onTap: { print("Close tapped") },
                        isPressed: $isPressed
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Edit Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonNav(
                        style: .edit(theme),
                        onTap: { print("Edit tapped") },
                        isPressed: $isPressed
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Save Button")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ButtonNav(
                        style: .save(theme),
                        onTap: { print("Save tapped") },
                        isPressed: $isPressed
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}
