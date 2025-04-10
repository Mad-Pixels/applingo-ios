import SwiftUI

internal struct ItemListView<Item: Identifiable & Equatable, RowContent: View>: View {
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

    var body: some View {
        ZStack {
            listView
            if isLoadingPage && items.isEmpty {
                ItemListLoading(style: style)
            }
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

    private var listView: some View {
        List {
            listContent
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(style.backgroundColor)
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
