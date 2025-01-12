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
                loadingOverlay
            }
        }
    }
    
    private var listView: some View {
        List {
            listContent
        }
        .listStyle(.insetGrouped)
        .listRowSeparator(.hidden)
        .scrollContentBackground(.hidden)
        .background(style.backgroundColor)
    }
    
    @ViewBuilder
    private var listContent: some View {
        if let error = error {
            errorView(error)
        }
        if items.isEmpty && !isLoadingPage {
            if let emptyView = emptyListView {
                emptyView
            }
        } else if !items.isEmpty {
            ForEach(items) { item in
                rowContent(item)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(style.backgroundColor)
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .onTapGesture {
                        onItemTap?(item)
                    }
                    .onAppear {
                        onItemAppear?(item)
                    }
            }
            .onDelete(perform: onDelete)
            
            if isLoadingPage {
                loadingIndicator
            }
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
            .foregroundColor(style.errorColor)
            .padding(style.padding)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 12)
                    .fill(style.backgroundColor)
            )
    }
    
    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(.circular)
                .padding(style.padding)
            Spacer()
        }
        .listRowBackground(
            RoundedRectangle(cornerRadius: 12)
                .fill(style.backgroundColor)
        )
    }
    
    private var loadingOverlay: some View {
        VStack {
            ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(style.loadingSize)
                .padding(style.padding)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(style.backgroundColor.opacity(0.2))
    }
}
