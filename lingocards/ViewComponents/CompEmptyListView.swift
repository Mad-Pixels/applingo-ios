import SwiftUI

struct CompEmptyListView: View {
    let theme: ThemeStyle
    let message: String

    var body: some View {
        Spacer()
        Text(message)
            .modifier(BaseTextStyle(theme: theme))
            .italic()
            .font(.title)
            .padding(.vertical, 5)
        Spacer()
    }
}
