import SwiftUI

struct CompWordListView: View {
    let words: [WordItem]
    let onWordTap: (WordItem) -> Void
    let onDelete: (IndexSet) -> Void
    let loadMoreIfNeeded: (WordItem) -> Void  // Принимает текущий элемент
    let theme: ThemeStyle

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(words, id: \.id) { word in
                    CompWordRowView(
                        word: word,
                        onTap: {
                            onWordTap(word)
                        },
                        theme: theme
                    )
                    .onAppear {
                        // Отладочное сообщение
                        print("👀 Появился элемент с id: \(word.id)")
                        loadMoreIfNeeded(word)  // Передаем текущий элемент
                    }
                    .padding(.vertical, 2)
                }
                .onDelete(perform: onDelete)
            }
        }
    }
}

