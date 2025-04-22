import SwiftUI

struct ItemList<Item: Identifiable & Equatable, RowContent: View>: View {
    @State private var pressedItemId: Item.ID?
    @Binding var items: [Item]
   
    let rowContent: (Item) -> RowContent
    let onItemAppear: ((Item) -> Void)?
    let onDelete: ((IndexSet) -> Void)?
    let onItemTap: ((Item) -> Void)?
    let canDelete: ((Item) -> Bool)?
    let emptyListView: AnyView?
    let style: ItemListStyle
    let isLoadingPage: Bool
    let error: Error?
    
    /// Initializes the ItemList.
    /// - Parameters:
    ///   - items: A binding to the array of items.
    ///   - style: The list style. Defaults to the themed style using the current theme.
    ///   - isLoadingPage: A Boolean value indicating whether a new page is currently loading.
    ///   - error: An optional error to display.
    ///   - emptyListView: A view to display when the list is empty.
    ///   - onItemAppear: A closure called when an item appears.
    ///   - onDelete: A closure called when an item is deleted.
    ///   - onItemTap: A closure called when an item is tapped.
    ///   - canDelete: A closure that determines whether a specific item can be deleted.
    ///   - rowContent: A view builder closure for rendering each row.
    init(
        items: Binding<[Item]>,
        style: ItemListStyle = .themed(ThemeManager.shared.currentThemeStyle),
        isLoadingPage: Bool = false,
        error: Error? = nil,
        emptyListView: AnyView? = nil,
        onItemAppear: ((Item) -> Void)? = nil,
        onDelete: ((IndexSet) -> Void)? = nil,
        onItemTap: ((Item) -> Void)? = nil,
        canDelete: ((Item) -> Bool)? = nil,
        @ViewBuilder rowContent: @escaping (Item) -> RowContent
    ) {
        self.isLoadingPage = isLoadingPage
        self.emptyListView = emptyListView
        self.onItemAppear = onItemAppear
        self.rowContent = rowContent
        self.canDelete = canDelete
        self.onItemTap = onItemTap
        self.onDelete = onDelete
        self._items = items
        self.style = style
        self.error = error
    }
    
    @ViewBuilder
    var body: some View {
        if #available(iOS 18, *) {
            ItemListView(
                items: $items,
                rowContent: rowContent,
                onItemAppear: onItemAppear,
                onDelete: onDelete,
                onItemTap: onItemTap,
                canDelete: canDelete,
                emptyListView: emptyListView,
                style: style,
                isLoadingPage: isLoadingPage,
                error: error
            )
        } else {
            ItemScrollView(
                items: $items,
                rowContent: rowContent,
                onItemAppear: onItemAppear,
                onDelete: onDelete,
                onItemTap: onItemTap,
                canDelete: canDelete,
                emptyListView: emptyListView,
                style: style,
                isLoadingPage: isLoadingPage,
                error: error
            )
        }
    }
    
    @ViewBuilder
    private var listContent: some View {
        if let error = error {
            ItemListError(error: error, style: style)
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
            if let canDelete = canDelete {
                let itemsWithIndex = items.enumerated().map { (index, item) in (index, item, canDelete(item)) }
                let deletableItems = itemsWithIndex.filter { $0.2 }
                let nonDeletableItems = itemsWithIndex.filter { !$0.2 }
                
                ForEach(nonDeletableItems, id: \.1.id) { _, item, _ in
                    ItemListRow(
                        pressedItemId: $pressedItemId,
                        item: item,
                        style: style,
                        onItemTap: onItemTap,
                        onItemAppear: onItemAppear,
                        rowContent: rowContent
                    )
                }
                
                ForEach(deletableItems, id: \.1.id) { _, item, _ in
                    ItemListRow(
                        pressedItemId: $pressedItemId,
                        item: item,
                        style: style,
                        onItemTap: onItemTap,
                        onItemAppear: onItemAppear,
                        rowContent: rowContent
                    )
                }
                .onDelete { indexSet in
                    let originalIndices = indexSet.map { deletableItems[$0].0 }
                    let originalIndexSet = IndexSet(originalIndices)
                    onDelete?(originalIndexSet)
                }
            } else {
                ForEach(items) { item in
                    ItemListRow(
                        pressedItemId: $pressedItemId,
                        item: item,
                        style: style,
                        onItemTap: onItemTap,
                        onItemAppear: onItemAppear,
                        rowContent: rowContent
                    )
                }
                .onDelete(perform: onDelete)
            }
            if isLoadingPage {
                loadingIndicator
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
