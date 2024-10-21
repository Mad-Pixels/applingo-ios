import SwiftUI

struct CompEmptyListView: View {
    let theme: ThemeStyle
    let message: String

    var body: some View {
        Spacer()
        Text(message)
            .modifier(TitleTextStyle(theme: theme))
        Spacer()
    }
}
