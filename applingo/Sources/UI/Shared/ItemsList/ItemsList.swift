import SwiftUI

struct ItemsList<Item: Identifiable & Equatable, RowContent: View>: View {
    // MARK: - Properties
    @Binding var items: [Item]
    let style: ItemsListStyle
    
    let isLoadingPage: Bool
    let error: Error?
    let emptyListView: AnyView?
    let rowContent: (Item) -> RowContent
    
    // Callbacks
    let onItemAppear: ((Item) -> Void)?
    let onDelete: ((IndexSet) -> Void)?
    let onItemTap: ((Item) -> Void)?
    
    // MARK: - Initialization
    
    init(
        items: Binding<[Item]>,
        style: ItemsListStyle = .themed(ThemeManager.shared.currentThemeStyle),
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
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            List {
                listContent
            }
            .background(style.backgroundColor)
            .scrollContentBackground(.hidden)
            
            if isLoadingPage && items.isEmpty {
                loadingOverlay
            }
        }
    }
    
    // MARK: - Private Views
    
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
            itemsList
        }
    }
    
    private var itemsList: some View {
        Group {
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
                loadingIndicator
            }
        }
    }
    
    private func errorView(_ error: Error) -> some View {
        Text("Error: \(error.localizedDescription)")
            .foregroundColor(style.errorColor)
            .padding(style.padding)
    }
    
    private var loadingIndicator: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding(style.padding)
            Spacer()
        }
    }
    
    private var loadingOverlay: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(style.loadingSize)
                .padding(style.padding)
        }
        .background(Color.clear)
    }
}
