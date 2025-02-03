import SwiftUI

// MARK: - ItemListLoadingOverlay
/// Displays an overlay with a loading indicator.
struct ItemListLoadingOverlay: View {
    let style: ItemListStyle
    
    var body: some View {
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
