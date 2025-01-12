import SwiftUI

struct TogglePreview_Previews: PreviewProvider {
    static var previews: some View {
        TogglePreview()
            .previewDisplayName("Toggle Styles")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct TogglePreview: View {
    @State private var isOnWithHeader = false
    @State private var isOnWithoutHeader = false
    
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
                    Text("Toggle without Header")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemToggle(
                        isOn: $isOnWithoutHeader,
                        title: "Enable notifications",
                        style: .themedCompact(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled Toggle with Header")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemToggle(
                        isOn: .constant(true),
                        title: "Disabled toggle",
                        header: "Disabled section",
                        style: .themed(theme)
                    )
                    .disabled(true)
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
