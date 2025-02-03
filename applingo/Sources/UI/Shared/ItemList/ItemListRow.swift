import SwiftUI

// MARK: - ItemListRow
/// Represents a single row in the item list with tap and appearance handling.
struct ItemListRow<Item: Identifiable, RowContent: View>: View {
    let item: Item
    let style: ItemListStyle
    @Binding var pressedItemId: Item.ID?
    let rowContent: (Item) -> RowContent
    let onItemTap: ((Item) -> Void)?
    let onItemAppear: ((Item) -> Void)?
    
    var body: some View {
        rowContent(item)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(pressedItemId == item.id ? style.ontapColor : style.backgroundColor)
            )
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        pressedItemId = item.id
                    }
                    .onEnded { _ in
                        pressedItemId = nil
                    }
            )
            .onTapGesture {
                onItemTap?(item)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onAppear {
                onItemAppear?(item)
            }
    }
}
