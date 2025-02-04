import SwiftUI

struct DictionaryLocalRow_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryLocalRowPreview()
            .previewDisplayName("Dictionary Row Component")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct DictionaryLocalRowPreview: View {
    static let previewModel = DictionaryLocalRowModel(
        title: "English - Russian",
        category: "Language",
        subcategory: "Basic",
        description: "Common English words and phrases",
        level: .advanced,
        isActive: true
    )
    
    static let languageModel = DictionaryLocalRowModel(
        title: "Language Model",
        category: "Language",
        subcategory: "ru-en",
        description: "Common English words and phrases",
        level: .advanced,
        isActive: true
    )
    
    static let inactiveModel = DictionaryLocalRowModel(
        title: "Spanish - Russian",
        category: "Language",
        subcategory: "Advanced",
        description: "Advanced Spanish vocabulary",
        level: .beginner,
        isActive: false
    )
    
    static let longTextModel = DictionaryLocalRowModel(
        title: "This is a very long dictionary title",
        category: "Special",
        subcategory: "Professional Terms",
        description: "A very detailed description of the dictionary content",
        level: .beginner,
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
                    Text(verbatim: "Active dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryLocalRow(
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
                    Text(verbatim: "Language dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryLocalRow(
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
                    Text(verbatim: "Inactive dictionary")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryLocalRow(
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
                    Text(verbatim: "Long text")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    DictionaryLocalRow(
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
