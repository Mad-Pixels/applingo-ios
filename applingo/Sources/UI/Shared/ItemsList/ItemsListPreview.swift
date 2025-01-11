import SwiftUI

struct ListItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

private struct ListPreview: View {
    @State private var emptyItems: [ListItem] = []
    @State private var items: [ListItem] = [
        ListItem(title: "Item 1"),
        ListItem(title: "Item 2"),
        ListItem(title: "Item 3")
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
            
            // Empty list
            VStack(alignment: .leading, spacing: 8) {
                Text("Empty list")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                ItemsList(
                    items: $emptyItems,
                    style: .themed(theme),
                    emptyListView: AnyView(
                        Text("No items")
                            .foregroundColor(theme.textSecondary)
                    )
                ) { item in
                    Text(item.title)
                }
                .frame(height: 100)
            }
            
            // Filled list
            VStack(alignment: .leading, spacing: 8) {
                Text("With items")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                ItemsList(
                    items: $items,
                    style: .themed(theme)
                ) { item in
                    Text(item.title)
                        .foregroundColor(theme.textPrimary)
                }
                .frame(height: 200)
            }
            
            // Loading state
            VStack(alignment: .leading, spacing: 8) {
                Text("Loading")
                    .font(.subheadline)
                    .foregroundColor(theme.textSecondary)
                
                ItemsList(
                    items: $emptyItems,
                    style: .themed(theme),
                    isLoadingPage: true
                ) { item in
                    Text(item.title)
                }
                .frame(height: 100)
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
    }
}

#Preview("List Component") {
    ListPreview()
}
