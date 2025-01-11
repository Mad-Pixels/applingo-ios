import SwiftUI

private struct PreviewDictionaryItem {
    let id: String
    let displayName: String
    let subTitle: String
    let isActive: Bool
}

// DictionaryPreview.swift
struct DictionaryPreview: View {
    private let previewItems = [
        PreviewDictionaryItem(
            id: "1",
            displayName: "English Dictionary",
            subTitle: "Common words and phrases",
            isActive: true
        ),
        PreviewDictionaryItem(
            id: "2",
            displayName: "Spanish Dictionary",
            subTitle: "Basic vocabulary",
            isActive: false
        ),
        PreviewDictionaryItem(
            id: "3",
            displayName: "French Dictionary (Disabled)",
            subTitle: "Advanced vocabulary",
            isActive: true
        )
    ]
    
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
            
            ForEach(previewItems, id: \.id) { item in
                DictionaryRow(
                    title: item.displayName,
                    subtitle: item.subTitle,
                    isActive: item.isActive,
                    style: .themed(theme),
                    onTap: { print("Tapped: \(item.displayName)") },
                    onToggle: { print("Toggled: \(item.displayName) to \($0)") }
                )
            }
            
            // Disabled state
            DictionaryRow(
                title: "Disabled Dictionary",
                subtitle: "This dictionary is disabled",
                isActive: false,
                style: .themed(theme),
                onTap: { },
                onToggle: { _ in }
            )
            .disabled(true)
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Dictionary Components") {
    DictionaryPreview()
}
