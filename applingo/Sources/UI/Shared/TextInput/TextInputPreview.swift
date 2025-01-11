import SwiftUI

struct TextInputPreview: View {
    @State private var inputText = ""
    @State private var areaText = ""
    
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
                // Regular TextInput
                TextInput(
                    text: $inputText,
                    placeholder: "Enter text",
                    style: .themed(theme)
                )
                
                // TextInput with icon
                TextInput(
                    text: $inputText,
                    placeholder: "Search",
                    icon: "magnifyingglass",
                    style: .themed(theme)
                )
                
                // TextInput with border
                TextInput(
                    text: $inputText,
                    placeholder: "With border",
                    border: true,
                    style: .themed(theme)
                )
                
                // Disabled TextInput
                TextInput(
                    text: .constant("Disabled input"),
                    placeholder: "Disabled",
                    isEditing: false,
                    style: .themed(theme)
                )
                
                // TextArea
                TextArea(
                    text: $areaText,
                    placeholder: "Enter long text",
                    style: .themed(theme)
                )
                
                // TextArea with icon
                TextArea(
                    text: $areaText,
                    placeholder: "Notes",
                    icon: "note.text",
                    style: .themed(theme)
                )
                
                // Disabled TextArea
                TextArea(
                    text: .constant("Disabled area"),
                    placeholder: "Disabled",
                    isEditing: false,
                    style: .themed(theme)
                )
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Text Input Components") {
    TextInputPreview()
}
