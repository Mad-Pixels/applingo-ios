import SwiftUI

private struct CheckboxPreview: View {
    @State private var isChecked = false
    @State private var isCheckedDisabled = true
    
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
            
            // Default state
            VStack(alignment: .leading, spacing: 8) {
                Text("Default state")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                Checkbox(
                    isChecked: $isChecked,
                    style: .themed(theme),
                    onChange: { newValue in
                        print("Checkbox changed to: \(newValue)")
                    }
                )
            }
            
            // Checked state
            VStack(alignment: .leading, spacing: 8) {
                Text("Checked state")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                Checkbox(
                    isChecked: .constant(true),
                    style: .themed(theme)
                )
            }
            
            // Disabled state
            VStack(alignment: .leading, spacing: 8) {
                Text("Disabled state")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                Checkbox(
                    isChecked: $isCheckedDisabled,
                    style: .themed(theme)
                )
                .disabled(true)
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Checkbox Component") {
    CheckboxPreview()
}
