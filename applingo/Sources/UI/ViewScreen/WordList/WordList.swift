import SwiftUI

struct WordList: View {
    @StateObject private var style: WordListStyle
    @StateObject private var locale = WordListLocale()
    @StateObject private var wordsGetter = WordsLocalGetterViewModel()
    
    @State private var selectedWord: WordItemModel?
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var errorMessage: String = ""
    
    init(style: WordListStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseViewScreen(screen: .words) {
            ZStack {
                VStack(spacing: style.spacing) {
                    WordListViewSearch(
                        searchText: $wordsGetter.searchText,
                        locale: locale
                    )
                    WordListViewList(
                        locale: locale,
                        wordsGetter: wordsGetter,
                        onWordSelect: { word in
                            selectedWord = word
                            isShowingDetailView = true
                        }
                    )
                }
                .navigationTitle(locale.navigationTitle)
                .navigationBarTitleDisplayMode(.large)
                
                WordListViewActions(
                    locale: locale,
                    onAdd: { isShowingAddView = true }
                )
            }
        }
        .sheet(isPresented: $isShowingAddView) {
            WordAddManual(
                isPresented: $isShowingAddView,
                refresh: { wordsGetter.resetPagination() }
            )
            .environmentObject(ThemeManager.shared)
            .environmentObject(LocaleManager.shared)
        }
        .sheet(item: $selectedWord) { word in
            WordDetails(
                word: word,
                isPresented: $isShowingDetailView,
                refresh: { wordsGetter.resetPagination() }
            )
            .environmentObject(ThemeManager.shared)
            .environmentObject(LocaleManager.shared)
        }
    }
}
