import SwiftUI

struct CompItemListView<Item: Identifiable & Equatable, RowContent: View>: View {
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
                    ForEach(items) { item in
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
            .background(ThemeManager.shared.currentThemeStyle.backgroundPrimary)
            .scrollContentBackground(.hidden)
            
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
