import SwiftUI

struct WordList: View {
    @StateObject private var style: WordListStyle
    @StateObject private var locale = WordListLocale()
    @StateObject private var wordsGetter = WordsLocalGetterViewModel()
    
    @State private var selectedWord: WordItemModel?
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    
    init(style: WordListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseScreen(
            screen: .words,
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
                
            }
            .overlay(alignment: .bottomTrailing) {
                WordListViewActions(
                    locale: locale,
                    onAdd: { isShowingAddView = true }
                )
                .padding(.bottom, 16)
                .padding(.trailing, 16)
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
