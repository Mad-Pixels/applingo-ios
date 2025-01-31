import SwiftUI

/// A view that displays a list of words with search and add functionalities.
struct WordList: View {
    
    // MARK: - State Objects
    
    /// Style configuration for the WordList view.
    @StateObject private var style: WordListStyle
    /// Localization object for the WordList view.
    @StateObject private var locale = WordListLocale()
    /// Object responsible for fetching words.
    @StateObject private var wordsGetter = WordGetter()
    
    // MARK: - Local State
    
    /// The selected word from the list.
    @State private var selectedWord: DatabaseModelWord?
    /// Flag to present the word details view.
    @State private var isShowingDetailView = false
    /// Flag to present the add word view.
    @State private var isShowingAddView = false
    
    // MARK: - Initializer
    
    /// Initializes the WordList view.
    /// - Parameter style: Optional style; if nil, a themed style is used.
    init(style: WordListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseScreen(
            screen: .WordList,
            title: locale.navigationTitle
        ) {
            VStack(spacing: 0) {
                WordListViewSearch(
                    searchText: $wordsGetter.searchText,
                    locale: locale
                )
                .padding()
                
                WordListViewList(
                    locale: locale,
                    wordsGetter: wordsGetter,
                    onWordSelect: { word in
                        selectedWord = word
                        isShowingDetailView = true
                    }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 130)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                WordListViewActions(
                    locale: locale,
                    onAdd: { isShowingAddView = true }
                )
                .padding(.bottom, 80)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedWord) { word in
            WordDetails(
                word: word,
                isPresented: $isShowingDetailView,
                refresh: { wordsGetter.resetPagination() }
            )
        }
        .sheet(isPresented: $isShowingAddView) {
            WordAddManual(
                isPresented: $isShowingAddView,
                refresh: { wordsGetter.resetPagination() }
            )
        }
    }
}
