import SwiftUI

struct DictionaryRow_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryRowPreview()
            .previewDisplayName("Dictionary Row Component")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct DictionaryRowPreview: View {
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
                // Active dictionary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Active dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryRow(
                        title: "English - Russian",
                        subtitle: "1234 words",
                        isActive: true,
                        style: .themed(theme),
                        onTap: { print("Tapped active dictionary") },
                        onToggle: { isActive in
                            print("Toggle dictionary: \(isActive)")
                        }
                    )
                }
                
                // Inactive dictionary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inactive dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryRow(
                        title: "Spanish - Russian",
                        subtitle: "567 words",
                        isActive: false,
                        style: .themed(theme),
                        onTap: { print("Tapped inactive dictionary") },
                        onToggle: { isActive in
                            print("Toggle dictionary: \(isActive)")
                        }
                    )
                }
                
                // Long text example
                VStack(alignment: .leading, spacing: 8) {
                    Text("Long text")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryRow(
                        title: "This is a very long dictionary title to test text wrapping",
                        subtitle: "This is a very long subtitle with detailed description",
                        isActive: true,
                        style: .themed(theme),
                        onTap: { print("Tapped long text dictionary") },
                        onToggle: { isActive in
                            print("Toggle dictionary: \(isActive)")
                        }
                    )
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
