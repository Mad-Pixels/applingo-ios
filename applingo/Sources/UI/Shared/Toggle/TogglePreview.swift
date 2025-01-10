import SwiftUI

struct TogglePreview: View {
    @State private var isOnWithHeader = false
    @State private var isOnWithoutHeader = false
    
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
            
            AppToggle(
                isOn: $isOnWithoutHeader,
                title: "Enable notifications",
                style: .themedCompact(theme)
            )
            
            AppToggle(
                isOn: .constant(true),
                title: "Disabled toggle",
                header: "Disabled section",
                style: .themed(theme)
            )
            .disabled(true)
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Toggle Styles") {
    TogglePreview()
}
