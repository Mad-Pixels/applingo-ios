import SwiftUI

// MARK: - ItemList View
/// Displays a list of items with loading, error, and empty state handling.
struct ItemList<Item: Identifiable & Equatable, RowContent: View>: View {
    @Binding var items: [Item]
    let style: ItemListStyle
    let isLoadingPage: Bool
    let error: Error?
    let emptyListView: AnyView?
    let rowContent: (Item) -> RowContent
    let onItemAppear: ((Item) -> Void)?
    let onDelete: ((IndexSet) -> Void)?
    let onItemTap: ((Item) -> Void)?
    
    @State private var pressedItemId: Item.ID?
    
    /// Initializes the ItemList.
    /// - Parameters:
    ///   - items: Binding to the array of items.
    ///   - style: The list style. Defaults to themed style using the current theme.
    ///   - isLoadingPage: Indicates if a new page is loading.
    ///   - error: An optional error to display.
    ///   - emptyListView: A view to show when the list is empty.
    ///   - onItemAppear: Closure called when an item appears.
    ///   - onDelete: Closure called when an item is deleted.
    ///   - onItemTap: Closure called when an item is tapped.
    ///   - rowContent: A view builder for rendering each row.
    init(
        items: Binding<[Item]>,
        style: ItemListStyle = .themed(ThemeManager.shared.currentThemeStyle),
        isLoadingPage: Bool = false,
        error: Error? = nil,
        emptyListView: AnyView? = nil,
        onItemAppear: ((Item) -> Void)? = nil,
        onDelete: ((IndexSet) -> Void)? = nil,
        onItemTap: ((Item) -> Void)? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self._items = items
        self.style = style
        self.isLoadingPage = isLoadingPage
        self.error = error
        self.emptyListView = emptyListView
        self.onItemAppear = onItemAppear
        self.onDelete = onDelete
        self.onItemTap = onItemTap
        self.rowContent = rowContent
    }
    
    var body: some View {
        ZStack {
            listView
            if isLoadingPage && items.isEmpty {
                ItemListLoadingOverlay(style: style)
            }
        }
    }
    
    /// The main list view.
    private var listView: some View {
        List {
            listContent
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(style.backgroundColor)
    }
    
    /// The content of the list with error, empty, and rows.
    @ViewBuilder
    private var listContent: some View {
        if let error = error {
            ItemListErrorView(error: error, style: style)
        }
        if items.isEmpty && !isLoadingPage {
            if let emptyView = emptyListView {
                emptyView
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .frame(maxWidth: .infinity)
                    .listRowSeparator(.hidden)
            }
        } else if !items.isEmpty {
            ForEach(items) { item in
                ItemListRow(
                    item: item,
                    style: style,
                    pressedItemId: $pressedItemId,
                    rowContent: rowContent,
                    onItemTap: onItemTap,
                    onItemAppear: onItemAppear
                )
            }
            .onDelete(perform: onDelete)
            
            if isLoadingPage {
                loadingIndicator
            }
        }
    }
    
    /// A loading indicator shown at the end of the list.
    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .padding(style.padding)
            Spacer()
        }
        .listRowBackground(Color.clear)
    }
}
