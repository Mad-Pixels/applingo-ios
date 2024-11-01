import Foundation
import SwiftUI

protocol ListItemProtocol: Identifiable, Equatable {
    var listId: Int { get }
}

struct CompItemListView<Item: ListItemProtocol, RowContent: View>: View {
    @Binding var items: [Item]
    
    var isLoadingPage: Bool
    var error: Error?
    var onItemAppear: ((Item) -> Void)?
    var onDelete: ((IndexSet) -> Void)?
    var onItemTap: ((Item) -> Void)?
    var emptyListView: AnyView?
    var rowContent: (Item) -> RowContent

    var body: some View {
        ZStack {
            List {
                if let error = error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                }

                if items.isEmpty && !isLoadingPage {
                    emptyListView
                } else if !items.isEmpty {
                    ForEach(items, id: \.listId) { item in
                        rowContent(item)
                            .onTapGesture {
                                onItemTap?(item)
                            }
                            .onAppear {
                                onItemAppear?(item)
                            }
                    }
                    .onDelete(perform: onDelete)

                    if isLoadingPage {
                        HStack {
                            Spacer()
                            ProgressView()
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            if isLoadingPage && items.isEmpty {
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                }
                .background(Color.clear)
            }
        }
    }
}
