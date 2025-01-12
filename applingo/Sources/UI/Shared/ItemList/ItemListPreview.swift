import SwiftUI

struct ListItem: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

struct ListPreview_Previews: PreviewProvider {
    static var previews: some View {
        ListPreview()
            .previewDisplayName("List Component")
            .previewLayout(.sizeThatFits)
            .padding()
    }
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
                    Text("Empty list")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemList(
                        items: $emptyItems,
                        style: .themed(theme),
                        emptyListView: AnyView(
                            Text("No items")
                                .foregroundColor(theme.textSecondary)
                        )
                    ) { item in
                        Text(item.title)
                            .foregroundColor(theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("With items")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemList(
                        items: $items,
                        style: .themed(theme)
                    ) { item in
                        Text(item.title)
                            .foregroundColor(theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 200)
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Loading")
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                    
                    ItemList(
                        items: $emptyItems,
                        style: .themed(theme),
                        isLoadingPage: true
                    ) { item in
                        Text(item.title)
                            .foregroundColor(theme.textPrimary)
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(theme.backgroundSecondary)
                    .cornerRadius(12)
                    .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                }
            }
        }
        .padding()
        .background(theme.backgroundPrimary)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}
