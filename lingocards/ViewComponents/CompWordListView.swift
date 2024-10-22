import SwiftUI

struct CompWordListView: View {
    let words: [WordItem]
    let onWordTap: (WordItem) -> Void
    let onDelete: (IndexSet) -> Void
    let loadMoreIfNeeded: (WordItem) -> Void  // Принимает текущий элемент
    let theme: ThemeStyle

    var body: some View {
        List {
            ForEach(words, id: \.uiID) { word in
                CompWordRowView(
                    word: word,
                    onTap: {
                        onWordTap(word)
                    },
                    theme: theme
                )
                .onAppear {
                    loadMoreIfNeeded(word)  // Передаем текущий элемент
                }
                .padding(.vertical, 2)
            }
            .onDelete(perform: onDelete)
        }
    }
}
