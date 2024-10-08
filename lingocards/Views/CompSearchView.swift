import SwiftUI

struct CompSearchView: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)

            ZStack(alignment: .leading) {
                if searchText.isEmpty {
                    Text("Search...")
                        .foregroundColor(.gray)
                }
                
                TextField("", text: $searchText)
                    .foregroundColor(.primary)
            }
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
