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
    static let previewModel = DictionaryRowModel(
        title: "English - Russian",
        category: "Language",
        subcategory: "Basic",
        description: "Common English words and phrases",
        wordsCount: 1234,
        isActive: true
    )
    
    static let languageModel = DictionaryRowModel(
        title: "Language Model",
        category: "Language",
        subcategory: "ru-en",
        description: "Common English words and phrases",
        wordsCount: 1234,
        isActive: true
    )
    
    static let inactiveModel = DictionaryRowModel(
        title: "Spanish - Russian",
        category: "Language",
        subcategory: "Advanced",
        description: "Advanced Spanish vocabulary",
        wordsCount: 567,
        isActive: false
    )
    
    static let longTextModel = DictionaryRowModel(
        title: "This is a very long dictionary title",
        category: "Special",
        subcategory: "Professional Terms",
        description: "A very detailed description of the dictionary content",
        wordsCount: 999,
        isActive: true
    )
    
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
                        model: Self.previewModel,
                        style: .themed(theme),
                        onTap: { print("Tapped active dictionary") },
                        onToggle: { isActive in
                            print("Toggle dictionary: \(isActive)")
                        }
                    )
                }
                
                // Language dictionary
                VStack(alignment: .leading, spacing: 8) {
                    Text("Language dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryRow(
                        model: Self.languageModel,
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
                        model: Self.inactiveModel,
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
                        model: Self.longTextModel,
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
