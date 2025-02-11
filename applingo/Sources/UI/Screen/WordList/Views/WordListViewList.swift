import SwiftUI

/// A view that displays a list of words with pagination and deletion support.
struct WordListViewList: View {
    // MARK: - Properties
    @EnvironmentObject private var themeManager: ThemeManager
    private let locale: WordListLocale
    private let style: WordListStyle
    
    private let onWordSelect: (DatabaseModelWord) -> Void
    @ObservedObject private var wordsAction: WordAction
    @ObservedObject private var wordsGetter: WordGetter
    
    // MARK: - Initializer
    /// Initializes the word list view with localization and a data source.
    /// - Parameters:
    ///   - style: `WordListStyle` object that defines the visual style.
    ///   - locale: `WordListLocale` object that provides localized strings.
    ///   - wordsGetter: Object responsible for fetching words.
    ///   - wordsAction: `WordAction` object that is injected from the parent view.
    ///   - onWordSelect: Closure executed when a word is tapped.
    init(
        style: WordListStyle,
        locale: WordListLocale,
        wordsGetter: WordGetter,
        wordsAction: WordAction,
        onWordSelect: @escaping (DatabaseModelWord) -> Void
    ) {
        self.locale = locale
        self.style = style
        self.wordsGetter = wordsGetter
        self.wordsAction = wordsAction
        self.onWordSelect = onWordSelect
    }
    
    // MARK: - Body
    var body: some View {
        let wordsBinding = Binding<[DatabaseModelWord]>(
            get: { wordsGetter.words },
            set: { newValue in
                Logger.warning("[WordListViewList]: Attempt to modify read-only words binding")
            }
        )
        
        ItemList<DatabaseModelWord, WordRow>(
            items: wordsBinding,
            style: .themed(themeManager.currentThemeStyle),
            isLoadingPage: wordsGetter.isLoadingPage,
            error: nil,
            emptyListView: emptyStateView,
            onItemAppear: { word in wordsGetter.loadMoreWordsIfNeeded(currentItem: word) },
            onDelete: delete
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
                    wordsGetter.removeWord(word)
                }
            }
        }
    }
    
    /// A computed property that returns a view for the empty state.
    private var emptyStateView: AnyView {
        if wordsGetter.searchText.isEmpty &&
            wordsGetter.words.isEmpty &&
            !wordsGetter.isLoadingPage
        {
            return AnyView(WordListViewWelcome(style: style, locale: locale))
        } else {
            return AnyView(WordListViewNoItems(style: style, locale: locale))
        }
    }
}
