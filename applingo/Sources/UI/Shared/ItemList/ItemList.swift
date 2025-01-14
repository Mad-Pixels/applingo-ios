import SwiftUI

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
    
    private var listView: some View {
        List {
            listContent
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(style.backgroundColor)
    }
    
    @ViewBuilder
    private var listContent: some View {
        if let error = error {
            ItemListErrorView(error: error, style: style)
        }
        if items.isEmpty && !isLoadingPage {
            if let emptyView = emptyListView {
                emptyView
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
