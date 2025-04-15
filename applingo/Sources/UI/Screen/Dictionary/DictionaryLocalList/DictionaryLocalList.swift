import SwiftUI

struct DictionaryLocalList: View {
    private let overlayBottomPadding: CGFloat = 80
    private let bottomInsetHeight: CGFloat = 130
    
    @StateObject private var style: DictionaryLocalListStyle
    @StateObject private var locale = DictionaryLocalListLocale()
    @StateObject private var dictionaryGetter = DictionaryGetter()
    @StateObject private var dictionaryAction = DictionaryAction()
    
    @State private var selectedDictionary: DatabaseModelDictionary?
    @State private var isShowingImportSheet = false
    @State private var isShowingRemoteList = false
    @State private var isShowingNearbySend = false
   
    /// Initializes the DictionaryLocalList.
    /// - Parameter style: Optional style configuration; if nil, a themed style is used.
    init(style: DictionaryLocalListStyle = .themed(ThemeManager.shared.currentThemeStyle)) {
        _style = StateObject(wrappedValue: style)
    }
    
    var body: some View {
        BaseScreen(
            screen: .DictionaryLocalList,
            title: locale.screenTitle
        ) {
            VStack(spacing: 0) {
                DictionaryLocalListViewSearch(
                    style: style,
                    locale: locale,
                    searchText: $dictionaryGetter.searchText
                )
                .padding()
                
                DictionaryLocalListViewList(
                    style: style,
                    locale: locale,
                    dictionaryGetter: dictionaryGetter,
                    dictionaryAction: dictionaryAction,
                    onDictionarySelect: { dictionary in selectedDictionary = dictionary }
                )
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: bottomInsetHeight)
                }
            }
            .overlay(alignment: .bottomTrailing) {
                DictionaryLocalListViewActions(
                    style: style,
                    locale: locale,
                    onImport: { isShowingImportSheet = true },
                    onDownload: { isShowingRemoteList = true },
                    onNearbySend: { isShowingNearbySend = true }
                )
                .padding(.bottom, overlayBottomPadding)
            }
            .onAppear {
                dictionaryAction.setScreen(.DictionaryLocalList)
                dictionaryGetter.setScreen(.DictionaryLocalList)
                if dictionaryGetter.dictionaries.isEmpty {
                    dictionaryGetter.resetPagination()
                }
            }
            .onDisappear() {
                dictionaryGetter.searchText = ""
                dictionaryGetter.clear()
            }
        }
        .sheet(item: $selectedDictionary) { dictionary in
            DictionaryLocalDetails(
                dictionary: dictionary,
                refresh: { dictionaryGetter.resetPagination() }
            )
        }
        .fullScreenCover(isPresented: $isShowingImportSheet) {
            DictionaryImport(isPresented: $isShowingImportSheet)
        }
        .fullScreenCover(isPresented: $isShowingRemoteList) {
            DictionaryRemoteList()
        }
        .fullScreenCover(isPresented: $isShowingNearbySend) {
            DictionaryNearByDescription(isPresented: $isShowingNearbySend)
        }
    }
}
