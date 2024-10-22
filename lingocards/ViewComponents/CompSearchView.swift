import SwiftUI

struct CompSearchView: View {
    @Binding var searchText: String
    let placeholder: String
    let theme: ThemeStyle

    init(searchText: Binding<String>, placeholder: String, theme: ThemeStyle) {
        self._searchText = searchText
        self.placeholder = placeholder
        self.theme = theme
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .modifier(SecondaryIconStyle(theme: theme))

            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(placeholder)
                        .foregroundColor(theme.secondaryTextColor)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.red)
            }

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .modifier(SecondaryIconStyle(theme: theme))
                }
            }
        }
        .modifier(BaseSearchStyle(theme: theme))
        .padding(.bottom, 16)
    }
}
