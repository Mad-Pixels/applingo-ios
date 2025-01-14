import SwiftUI

struct ItemListErrorView: View {
    let error: Error
    let style: ItemListStyle
    
    var body: some View {
        Text("Error: \(error.localizedDescription)")
            .foregroundColor(style.errorColor)
            .listRowBackground(Color.clear)
            .padding(style.padding)
    }
}
