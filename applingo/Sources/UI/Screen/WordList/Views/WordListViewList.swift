import SwiftUI

struct WordListViewList: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var wordsAction = WordAction()
    @ObservedObject var wordsGetter: WordGetter
    private let locale: WordListLocale
    let onWordSelect: (DatabaseModelWord) -> Void
    
    init(
        locale: WordListLocale,
        wordsGetter: WordGetter,
        onWordSelect: @escaping (DatabaseModelWord) -> Void
    ) {
        self.locale = locale
        self.wordsGetter = wordsGetter
        self.onWordSelect = onWordSelect
    }
    
    var body: some View {
        let wordsBinding = Binding(
            get: { wordsGetter.words },
            set: { _ in }
        )
        
        ItemList<DatabaseModelWord, WordRow>(
            items: wordsBinding,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: wordsGetter.isLoadingPage,
            error: nil,
            emptyListView: AnyView(Text(locale.emptyMessage)),
            onItemAppear: { word in
                wordsGetter.loadMoreWordsIfNeeded(currentItem: word)
            },
            onDelete: delete,
            onItemTap: onWordSelect
        ) { word in
            WordRow(
                model: WordRowModel(
                    frontText: word.frontText,
                    backText: word.backText,
                    weight: word.weight
                ),
                style: .themed(themeManager.currentThemeStyle),
                onTap: {
                    onWordSelect(word)
                }
            )
        }
        .onAppear {
            wordsGetter.resetPagination()
        }
    }
    
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = wordsGetter.words[index]
            wordsAction.delete(word) { result in
                if case .success = result {
                    wordsGetter.removeWord(word)
                }
            }
        }
    }
}
