import SwiftUI

internal struct ItemScrollView<Item: Identifiable & Equatable, RowContent: View>: View {
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

    private let deleteText = LocaleManager.shared.localizedString(for: "base.button.delete")

    var body: some View {
        ZStack {
            if items.isEmpty && !isLoadingPage {
                emptyListView
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        if let error = error {
                            ItemListError(error: error, style: style)
                        }

                        ForEach(items) { item in
                            let isDeletable = canDelete?(item) ?? true
                            row(item)
                                .id(item.id)
                                .onAppear { onItemAppear?(item) }
                                .transaction { $0.disablesAnimations = true }
                                .task {
                                    _ = LocaleManager.shared.currentLocale
                                }
                                .contextMenu {
                                    if isDeletable {
                                        Button(role: .destructive) {
                                            delete(item)
                                        } label: {
                                            Label(deleteText, systemImage: "trash")
                                        }
                                    }
                                }
                        }

                        if isLoadingPage {
                            loadingIndicator
                        }
                    }
                    .padding(.bottom, 20)
                }
                .background(style.backgroundColor)
            }
        }
    }

    private func row(_ item: Item) -> some View {
        ItemListRow(
            pressedItemId: $pressedItemId,
            item: item,
            style: style,
            onItemTap: onItemTap,
            onItemAppear: onItemAppear,
            rowContent: rowContent
        )
        .frame(maxWidth: .infinity)
        .padding(.horizontal, style.rowListInsets.leading)
    }

    private func delete(_ item: Item) {
        guard let index = items.firstIndex(of: item) else { return }
        onDelete?(IndexSet(integer: index))
    }

    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .padding(style.padding)
            Spacer()
        }
    }
}
