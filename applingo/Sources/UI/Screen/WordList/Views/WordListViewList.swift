import SwiftUI

/// A view that displays a list of words with pagination and deletion support.
struct WordListViewList: View {
    
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var wordsAction = WordAction()
    @ObservedObject var wordsGetter: WordGetter
    
    // MARK: - Properties
    
    private let locale: WordListLocale
    /// Closure executed when a word is selected.
    let onWordSelect: (DatabaseModelWord) -> Void
    
    // MARK: - Initializer
    
    /// Initializes the word list view with localization and a data source.
    /// - Parameters:
    ///   - locale: Localization object.
    ///   - wordsGetter: Object responsible for fetching words.
    ///   - onWordSelect: Closure executed when a word is tapped.
    init(
        locale: WordListLocale,
        wordsGetter: WordGetter,
        onWordSelect: @escaping (DatabaseModelWord) -> Void
    ) {
        self.locale = locale
        self.wordsGetter = wordsGetter
        self.onWordSelect = onWordSelect
    }
    
    // MARK: - Body
    
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
    
    // MARK: - Private Methods
    
    /// Deletes the word at specified offsets.
    /// - Parameter offsets: IndexSet representing the positions of words to delete.
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
