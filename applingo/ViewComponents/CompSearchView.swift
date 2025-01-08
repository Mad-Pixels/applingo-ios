import SwiftUI

struct CompSearchView: View {
    @Binding var searchText: String
    let placeholder: String

    init(searchText: Binding<String>, placeholder: String) {
        self._searchText = searchText
        self.placeholder = placeholder
    }

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .modifier(SecondaryIconStyle())

            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text(placeholder)
                        .foregroundColor(ThemeManager.shared.currentThemeStyle.textSecondary)
                }
                TextField("", text: $searchText)
                    .foregroundColor(.red)
            }

            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .modifier(SecondaryIconStyle())
                }
            }
        }
        .modifier(BaseSearchStyle())
        .padding(.bottom, 16)
    }
}
