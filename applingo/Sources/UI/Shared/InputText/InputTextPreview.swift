import SwiftUI

struct TextInputPreview_Previews: PreviewProvider {
    static var previews: some View {
        TextInputPreview()
            .previewDisplayName("Text Input Components (Light & Dark Mode)")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct TextInputPreview: View {
    @State private var inputText = ""
    @State private var areaText = ""
    
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
                    Text("Regular Text Input")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputText(
                        text: $inputText,
                        placeholder: "Enter text",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Input with Icon")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputText(
                        text: $inputText,
                        placeholder: "Search",
                        icon: "magnifyingglass",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Input with Border")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputText(
                        text: $inputText,
                        placeholder: "With border",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled Text Input")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputText(
                        text: .constant("Disabled input"),
                        placeholder: "Disabled",
                        isEditing: false,
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Area")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputTextArea(
                        text: $areaText,
                        placeholder: "Enter long text",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Text Area with Icon")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputTextArea(
                        text: $areaText,
                        placeholder: "Notes",
                        icon: "note.text",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled Text Area")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    InputTextArea(
                        text: .constant("Disabled area"),
                        placeholder: "Disabled",
                        isEditing: false,
                        style: .themed(theme)
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}
