import SwiftUI

struct SearchPreview_Previews: PreviewProvider {
    static var previews: some View {
        SearchPreview()
            .previewDisplayName("Search Component (Light & Dark Mode)")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

private struct SearchPreview: View {
    @State private var searchText = ""
    
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
                    Text("Empty State")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    AppSearch(
                        text: $searchText,
                        placeholder: "Search items...",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("With Text")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    AppSearch(
                        text: .constant("Search query"),
                        placeholder: "Search items...",
                        style: .themed(theme)
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Disabled State")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    AppSearch(
                        text: .constant("Disabled search"),
                        placeholder: "Search items...",
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
