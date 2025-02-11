import SwiftUI

/// A view that displays a list of words with search and add functionalities.
struct WordList: View {
    
    // MARK: - State Objects
    
    @StateObject private var style: WordListStyle
    @StateObject private var locale = WordListLocale()
    @StateObject private var wordsGetter = WordGetter()
    @StateObject private var wordsAction = WordAction()
    
    // MARK: - Local State
    
    @State private var selectedWord: DatabaseModelWord?
    @State private var isShowingDetailView = false
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
            title: locale.screenTitle
        ) {
            VStack(spacing: 0) {
                WordListViewSearch(
                    style: style,
                    locale: locale,
                    searchText: $wordsGetter.searchText
                    
                )
                .padding()
                
                WordListViewList(
                    style: style,
                    locale: locale,
                    wordsGetter: wordsGetter,
                    wordsAction: wordsAction,
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
