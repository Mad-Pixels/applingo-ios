import SwiftUI

struct CheckboxPreview_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxPreview()
            .previewDisplayName("Checkbox Component")
            .previewLayout(.fixed(width: 350, height: 600))
            .padding()
    }
}

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
            .frame(maxWidth: .infinity)
        }
    }

    private func previewSection(_ title: String, theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.headline)
                .foregroundColor(theme.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Group {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Default state")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemCheckbox(
                        isChecked: $isChecked,
                        onChange: { newValue in
                            print("Checkbox changed to: \(newValue)")
                        },
                        style: .themed(theme)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Checked state")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemCheckbox(
                        isChecked: .constant(true),
                        style: .themed(theme)
                    )
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled state")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemCheckbox(
                        isChecked: $isCheckedDisabled,
                        disabled: true,
                        style: .themed(theme)
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundSecondary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .frame(maxWidth: .infinity)
    }
}
