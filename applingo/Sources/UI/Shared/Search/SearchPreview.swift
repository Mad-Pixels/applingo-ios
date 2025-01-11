import SwiftUI

struct SearchPreview: View {
    @State private var searchText = ""
    
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
            
            // Empty state
            AppSearch(
                text: $searchText,
                placeholder: "Search items...",
                style: .themed(theme)
            )
            
            // With text
            AppSearch(
                text: .constant("Search query"),
                placeholder: "Search items...",
                style: .themed(theme)
            )
            
            // Disabled state
            AppSearch(
                text: .constant("Disabled search"),
                placeholder: "Search items...",
                style: .themed(theme)
            )
            .disabled(true)
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("Search Component") {
    SearchPreview()
}
