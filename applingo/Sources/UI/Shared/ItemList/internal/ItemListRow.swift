import SwiftUI

internal struct ItemListRow<Item: Identifiable, RowContent: View>: View {
    @Binding var pressedItemId: Item.ID?
    
    internal let item: Item
    internal let style: ItemListStyle
    internal let onItemTap: ((Item) -> Void)?
    internal let onItemAppear: ((Item) -> Void)?
    internal let rowContent: (Item) -> RowContent
    
    var body: some View {
        var base = rowContent(item)
            .padding(.vertical, style.rowVerticalPadding)
            .padding(.horizontal, style.rowHorizontalPadding)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: style.rowCornerRadius)
                    .fill(pressedItemId == item.id ? style.ontapColor : style.backgroundColor)
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
        
        return base.ifIOS18 { view in
            view.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        pressedItemId = item.id
                    }
                    .onEnded { _ in
                        pressedItemId = nil
                    }
            )
        }
    }
}
