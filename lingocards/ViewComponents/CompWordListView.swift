import SwiftUI

struct CompWordListView: View {
    let words: [WordItem]
    let onWordTap: (WordItem) -> Void
    let onDelete: (IndexSet) -> Void
    let loadMoreIfNeeded: (WordItem) -> Void
    let theme: ThemeStyle

    var body: some View {
        List {
            ForEach(words, id: \.uiID) { word in
                CompWordRowView(word: word, onTap: {
                    onWordTap(word)
                }, theme: theme)
                .onAppear {
                    loadMoreIfNeeded(word)
                }
            }
            .onDelete(perform: onDelete)
        }
        .listStyle(PlainListStyle())
    }
}
