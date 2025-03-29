import SwiftUI

struct WordList: View {
    private let overlayBottomPadding: CGFloat = 80
    private let bottomInsetHeight: CGFloat = 130
    
    @StateObject private var style: WordListStyle
    @StateObject private var locale = WordListLocale()
    @StateObject private var wordsGetter = WordGetter()
    @StateObject private var wordsAction = WordAction()
    
    @State private var selectedWord: DatabaseModelWord?
    @State private var isSearchDisabled = false
    @State private var isShowingAddView = false
    
    /// Initializes the WordList.
    /// - Parameter style: The style for the picker. Defaults to themed style using the current theme.
    init(
        style: WordListStyle = .themed(ThemeManager.shared.currentThemeStyle)
    ) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .WordList,
            title: locale.screenTitle
        ) {
            VStack(spacing: 0) {
                WordListViewSearch(
                    style: style,
                    locale: locale,
                    searchText: $wordsGetter.searchText,
                    isDisabled: isSearchDisabled
                )
                .padding()
                
                WordListViewList(
                    style: style,
                    locale: locale,
                    wordsGetter: wordsGetter,
                    wordsAction: wordsAction,
                    onWordSelect: { word in selectedWord = word },
                    onListStateChanged: { isEmpty in
                        isSearchDisabled = isEmpty
                    }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: bottomInsetHeight)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                WordListViewActions(
                    style: style,
                    onAdd: { isShowingAddView = true }
                )
                .padding(.bottom, overlayBottomPadding)
            }
            .onAppear {
                if wordsGetter.words.isEmpty { wordsGetter.resetPagination() }
                wordsAction.setScreen(.WordList)
                wordsGetter.setScreen(.WordList)
            }
            .onDisappear() {
                wordsGetter.searchText = ""
                wordsGetter.clear()
            }
        }
        .sheet(item: $selectedWord) { word in
            WordDetails(
                word: word,
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
