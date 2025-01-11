import SwiftUI

struct ScreenWords: View {
    @StateObject private var style: ScreenWordsStyle
    @StateObject private var locale = ScreenWordsLocale()
    @StateObject private var wordsGetter = WordsLocalGetterViewModel()
    
    @State private var selectedWord: WordItemModel?
    @State private var isShowingDetailView = false
    @State private var isShowingAddView = false
    @State private var isShowingAlert = false
    @State private var errorMessage: String = ""
    
    init(style: ScreenWordsStyle? = nil) {
        let initialStyle = style ?? .themed(ThemeManager.shared.currentThemeStyle)
        _style = StateObject(wrappedValue: initialStyle)
    }
    
    var body: some View {
        BaseViewScreen(screen: .words) {
            ZStack {
                VStack(spacing: style.spacing) {
                    WordsSearch(
                        searchText: $wordsGetter.searchText,
                        locale: locale
                    )
                    WordsSection(
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
                
                WordsActions(
                    locale: locale,
                    onAdd: { isShowingAddView = true }
                )
            }
        }
        .sheet(isPresented: $isShowingAddView) {
            ScreenWordAdd(
                isPresented: $isShowingAddView,
                refresh: { wordsGetter.resetPagination() }
            )
            .environmentObject(ThemeManager.shared)
            .environmentObject(LocaleManager.shared)
        }
        .sheet(item: $selectedWord) { word in
            ScreenWordDetail(
                word: word,
                isPresented: $isShowingDetailView,
                refresh: { wordsGetter.resetPagination() }
            )
            .environmentObject(ThemeManager.shared)
            .environmentObject(LocaleManager.shared)
        }
    }
}
