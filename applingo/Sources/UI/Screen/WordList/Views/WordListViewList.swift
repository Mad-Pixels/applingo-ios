import SwiftUI

/// A view that displays a list of words with pagination and deletion support.
struct WordListViewList: View {
    
    // MARK: - Environment and Observed Objects
    
    @EnvironmentObject private var themeManager: ThemeManager
    @StateObject private var wordsAction = WordAction()
    @ObservedObject var wordsGetter: WordGetter
    
    // MARK: - Properties
    
    private let locale: WordListLocale
    private let style: WordListStyle
    let onWordSelect: (DatabaseModelWord) -> Void
    
    // MARK: - Initializer
    
    /// Initializes the word list view with localization and a data source.
    /// - Parameters:
    ///   - locale: Localization object.
    ///   - style: Style object.
    ///   - wordsGetter: Object responsible for fetching words.
    ///   - onWordSelect: Closure executed when a word is tapped.
    init(
        locale: WordListLocale,
        style: WordListStyle,
        wordsGetter: WordGetter,
        onWordSelect: @escaping (DatabaseModelWord) -> Void
    ) {
        self.locale = locale
        self.style = style
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
            emptyListView: emptyStateView,
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
    }

    // MARK: - Private Methods
    
    /// Deletes the word at specified offsets.
    /// - Parameter offsets: IndexSet representing the positions of words to delete.
    private func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let word = wordsGetter.words[index]
            wordsAction.delete(word) { result in
                if case .success = result {
                    Logger.debug("[WordList]: Successfully deleted word", metadata: [
                        "word": word.id.map(String.init) ?? "nil",
                        "frontText": word.frontText
                    ])
                    wordsGetter.removeWord(word)
                }
            }
        }
    }
    
    /// A computed property that returns a view for the empty state.
    private var emptyStateView: AnyView {
//        if wordsGetter.searchText.isEmpty && wordsGetter.words.isEmpty {
//            return AnyView(WordListViewWelcome())
//        } else {
            return AnyView(WordListViewNoItems(locale: locale, style: style))
        //}
    }
}
