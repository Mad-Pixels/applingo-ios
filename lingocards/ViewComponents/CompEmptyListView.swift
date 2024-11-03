import SwiftUI

struct CompEmptyListView: View {
    let message: String

    var body: some View {
        Spacer()
        Text(message)
            .modifier(BaseTextStyle())
            .italic()
            .font(.title)
            .padding(.vertical, 5)
        Spacer()
    }
}
