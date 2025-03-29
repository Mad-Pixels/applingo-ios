import SwiftUI

struct ItemListRow<Item: Identifiable, RowContent: View>: View {
    @Binding var pressedItemId: Item.ID?
    
    let item: Item
    let style: ItemListStyle
    let onItemTap: ((Item) -> Void)?
    let onItemAppear: ((Item) -> Void)?
    let rowContent: (Item) -> RowContent
    
    var body: some View {
        rowContent(item)
            .padding(.vertical, style.rowVerticalPadding)
            .padding(.horizontal, style.rowHorizontalPadding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: style.rowCornerRadius)
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
            .listRowInsets(style.rowListInsets)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .onAppear {
                onItemAppear?(item)
            }
    }
}
